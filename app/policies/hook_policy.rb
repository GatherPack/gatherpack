class HookPolicy < AdminPolicy
  def create?
    user&.architect?
  end

  def update?
    user&.architect?
  end
end
