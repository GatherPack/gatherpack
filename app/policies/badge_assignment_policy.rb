class BadgeAssignmentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def create?
    case record.badge.permission
    when "added_by_admin"
      user.admin?
    when "added_by_admin_or_self"
      true
    when "added_by_manager"
      (person.all_managed_teams.include?(record.badge.team)) || user.admin
    when "added_by_manager_or_self"
      true
    when "added_by_current_member"
      (person.all_teams.include?(record.badge.team)) || user.admin
    when "has_account"
      true
    end
  end

  def update?
    case record.badge.permission
    when "added_by_admin"
      user.admin?
    when "added_by_admin_or_self"
      user.admin? || person == record.person
    when "added_by_manager"
      (person.all_managed_teams.include?(record.badge.team) && record.person.all_teams.include?(record.badge.team)) || user.admin
    when "added_by_manager_or_self"
      (person.all_managed_teams.include?(record.badge.team) && record.person.all_teams.include?(record.badge.team)) || user.admin || person == record.person
    when "added_by_current_member"
      (person.all_teams.include?(record.badge.team) && record.person.all_teams.include?(record.badge.team)) || user.admin
    when "has_account"
      true
    end
  end

  def destroy?
    create?
  end
end
