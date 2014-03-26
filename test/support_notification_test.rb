require_relative './test_helper.rb'

describe 'SupportNotification' do
  let(:phone_numbers)        { %w[5551235555 5554565555] }
  let(:support_message)      { "I need help" }
  let(:support_notification) { SupportNotification.new(support_message) }

  before do
    ENV['TWILIO_NUMBER'] = '1234566789'
    ENV['SUPPORT_PHONE_NUMBERS'] = nil
    ENV['PROWL_API_KEYS'] = nil
  end

  it 'delivers the message to all phone numbers in SUPPORT_PHONE_NUMBERS' do
    ENV['SUPPORT_PHONE_NUMBERS'] = phone_numbers.join(",")

    Twilio.stub(:connect, '') do
      Twilio::Sms = Minitest::Mock.new
      phone_numbers.each do |phone_number|
        Twilio::Sms.expect :message, '',
          [ENV['TWILIO_NUMBER'], phone_number, support_message]
      end

      support_notification.deliver
    end
  end

  it 'delivers the message to all prowl keys in PROWL_API_KEYS' do
    ENV['PROWL_API_KEYS'] = '123'

    Prowl = Minitest::Mock.new
    Prowl.expect :add, '', [{
      apikey:      '123',
      application: "MOMMA",
      event:       "Support Request",
      description: support_message,
      priority:    2
    }]

    support_notification.deliver
  end
end
