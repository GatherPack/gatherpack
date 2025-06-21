class Gateway
  class PostmarkSendingGatewayPolicy < AdminPolicy
    def webhook?
      true
    end
  end
end
