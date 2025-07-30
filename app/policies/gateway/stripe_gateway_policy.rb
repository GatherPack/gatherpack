class Gateway
  class StripeGatewayPolicy < ArchitectPolicy
    def webhook?
      true
    end
  end
end
