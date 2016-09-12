require 'bundler/setup'
require 'twilio'
require 'prowl'

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  # Dotenv is great for development, optional for production
end

class SupportNotification
  @queue = "support"

  def self.perform(message, requested_at)
    new(message).deliver
  end

  def initialize(message)
    @message = message
  end

  attr_reader :message

  def deliver
    twilio
    prowl
    slack
  end

  def twilio
    Twilio.connect(ENV['TWILIO_SID'], ENV['TWILIO_AUTH'])

    phone_numbers.each do |number|
      Twilio::Sms.message(ENV['TWILIO_NUMBER'], number, message)
    end
  end

  def prowl
    prowl_api_keys.each do |key|
      Prowl.add(
        apikey:      key,
        application: "MOMMA",
        event:       "Support Request",
        description: message,
        priority:    2
      )
    end
  end

  def slack
    `curl -X POST --data-urlencode 'payload={"channel": "#ctmom_2016", "username": "webhookbot", "text": "<!channel> Support requested at #{message}", "icon_emoji": ":poop:"}' #{slack_url}`
  end

  private

  def phone_numbers
    ENV['SUPPORT_PHONE_NUMBERS'].to_s.split(",")
  end

  def prowl_api_keys
    ENV['PROWL_API_KEYS'].to_s.split(",")
  end

  def slack_url
    ENV['SLACK_URL']
  end
end
