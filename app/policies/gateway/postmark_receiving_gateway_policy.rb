class Gateway
  class PostmarkReceivingGatewayPolicy < ArchitectPolicy
    def webhook?
      true
    end
  end
end
