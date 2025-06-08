class FinalizeGatewaySetupJob < ApplicationJob
  queue_as :default

  def perform(gateway)
    gateway.finish_setup
  end
end
