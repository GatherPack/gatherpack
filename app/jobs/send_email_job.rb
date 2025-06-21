class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(gateway, address, subject, body)
    gateway.send_message(address, subject, body)
  end
end
