class ProcessGatewayWebhookJob < ApplicationJob
  queue_as :default

  def perform(gateway, payload, headers)
    gateway.handle_webhook(payload, headers)
  end
end
