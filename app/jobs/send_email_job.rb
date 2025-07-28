class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(gateway, address, subject, body)
    if gateway
      gateway.send_message(address, subject, body)
    else
      puts "No email gateway configured. Cannot send email."
      puts Gateway.registry.inspect
    end
  end
end
