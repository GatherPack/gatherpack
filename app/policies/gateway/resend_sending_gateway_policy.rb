class Gateway
  class ResendSendingGatewayPolicy < ArchitectPolicy
    def webhook?
      true
    end
  end
end
