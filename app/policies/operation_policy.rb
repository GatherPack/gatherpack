class OperationPolicy < AdminPolicy
  def create?
    user&.architect?
  end

  def update?
    user&.architect?
  end

  def run?
    return true if user.present? && user.admin
    case record.permission
    when "user"
      user.present?
    when "related"
      user.present? && person.related_to?(record.target)
    when "team"
      record&.target&.team ? person.all_teams.include?(record.target.team) : false
    when "manager"
      record.target&.team ? record.target.team.manager?(person) : false
    when "admin"
      user.admin
    else
      user.admin
    end
  end
end
