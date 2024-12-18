class BadgeAssignmentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def create?
    case record.badge.permission
    when 'added_by_admin'
      user.admin?
    when 'added_by_manager'
      (person.managed_teams.include?(record.badge.team)) || user.admin
    when 'added_by_current_member'
      (person.teams.include?(record.badge.team)) || user.admin
    when 'has_account'
      true
    end
  end

  def update?
    case record.badge.permission
    when 'added_by_admin'
      user.admin?
    when 'added_by_manager'
      (person.managed_teams.include?(record.badge.team) && record.person.teams.include?(record.badge.team)) || user.admin
    when 'added_by_current_member'
      (person.teams.include?(record.badge.team) && record.person.teams.include?(record.badge.team)) || user.admin
    when 'has_account'
      true
    end
  end

  def destroy?
    create?
  end
end
