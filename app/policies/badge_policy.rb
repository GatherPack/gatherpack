class BadgePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.all_teams).or(scope.where(team_id: nil))
      end
    end
  end

  def new?
     user.admin || person.all_managed_teams.present?
  end

  def create?
    user.admin || (record.badge.team && person.all_managed_teams.include?(record.badge.team))
  end

  def update?
    case record.permission
    when "added_by_admin"
      user.admin
    when "added_by_admin_or_self"
      true
    when "added_by_manager"
      (person.all_managed_teams.include?(record.team)) || user.admin
    when "added_by_current_member"
      (person.all_teams.include?(record.team)) || user.admin
    when "added_by_manager_or_self"
      true
    when "has_account"
      true
    else
      user.admin
    end
  end

  def edit?
    (person.all_managed_teams.include?(record.team) && !record.permission == "added_by_admin") || user.admin
  end

  def destroy?
    edit?
  end
end
