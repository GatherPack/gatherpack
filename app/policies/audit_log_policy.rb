class AuditLogPolicy < AdminPolicy
  def revert?
    user&.admin
  end
end
