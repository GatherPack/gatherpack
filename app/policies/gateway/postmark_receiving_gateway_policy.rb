class Gateway
  class PostmarkReceivingGatewayPolicy < AdminPolicy
    def webhook?
      true
    end
  end
end
