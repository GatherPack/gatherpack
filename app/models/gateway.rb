class Gateway < ApplicationRecord
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

  def gateway_name
    self.class.to_s.split("::").last
  end
end
