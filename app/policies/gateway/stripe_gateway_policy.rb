class Gateway
  class StripeGatewayPolicy < AdminPolicy
    def webhook?
      true
    end
  end
end
