class ProcessGatewayWebhookJob < ApplicationJob
  queue_as :default

  def perform(gateway, payload, signature)
    gateway.handle_webhook(payload, signature)
  end
end
