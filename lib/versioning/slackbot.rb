require 'slack-notifier'
module Versioning
  class Slackbot
    def initialize(bot_name, webhook)
      @slack = ::Slack::Notifier.new(
          webhook,
          icon_url: "https://emoji.slack-edge.com/T029T8PL3/amasin/44186c586fd6b087.jpg",
          username: bot_name
      )
    end

    def send_message(message, attatchments)
      begin
        @slack.ping message, attatchments
      rescue => e
        say("Error while trying to slack the message: #{e.message}", :red)
      end
    end
  end
end
