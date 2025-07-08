class GatewayPolicy < AdminPolicy
  def webhook?
    true
  end
end
