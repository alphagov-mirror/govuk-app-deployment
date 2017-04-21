require 'http'

class SlackAnnouncer
  def initialize(environment_name, slack_url)
    @environment_name = environment_name
    @slack_url = slack_url
  end

  def announce(repo_name, application, slack_channel = "#2ndline")
    return unless %w(production staging).include?(@environment_name)

    text = "<https://github.com/alphagov/#{repo_name}|#{application}> was just deployed to *#{@environment_name}*"

    url = dashboard_url(dashboard_host_name, repo_name)
    if url
      text += "\n:chart_with_upwards_trend: Why not check out the <#{url}|#{application} deployment dashboard>?"
    end

    message_payload = {
      username: "Badger",
      icon_emoji: ":badger:",
      text: text,
      mrkdwn: true,
      channel: slack_channel,
    }

    HTTP.post(@slack_url, body: JSON.dump(message_payload))
  rescue => e
    puts "Release notification to slack failed: #{e.message}"
  end

  def dashboard_host_name
    {
      "production" => "grafana.publishing.service.gov.uk",
      "staging" => "grafana.staging.publishing.service.gov.uk",
    }[@environment_name]
  end

  def dashboard_url(host_name, application_name)
    url = "https://grafana.publishing.service.gov.uk/api/dashboards/file/deployment_#{application_name}.json"
    return nil unless (200..399).cover?(HTTP.get(url).code)

    "https://#{host_name}/dashboard/file/deployment_#{application_name}.json"
  rescue => e
    puts "Unable to connect to grafana server: #{e.message}"
    nil
  end
end
