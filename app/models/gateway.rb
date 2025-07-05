class Gateway < ApplicationRecord
  has_neat_id :gw
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }

  class << self
    def registry
      @@registry ||= {}
    end

    def register(klass, svc)
      registry[svc] ||= []
      registry[svc] << klass
    end

    def any_registered?(svc)
      registry[svc] ||= []
      registry[svc].flat_map(&:all).any?
    end

    def registered(svc)
      registry[svc].flat_map(&:all)
    end
  end

  after_create :start_finalizing_setup

  def start_finalizing_setup
    FinalizeGatewaySetupJob.perform_later(self)
  end

  def gateway_name
    self.class.to_s.split("::").last
  end

  def finish_setup
  end

  def handle_webhook(payload, signature)
  end
end
