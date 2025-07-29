class Gateway
  class PostmarkSendingGatewayPolicy < ArchitectPolicy
    def webhook?
      true
    end
  end
end
