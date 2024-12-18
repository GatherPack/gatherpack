class BadgePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.teams).or(scope.where(team_id: nil))
      end
    end
  end

  def new?
    person.managed_teams.present? || user.admin
  end

  def create?
    person.managed_teams.include?(record.team) || user.admin
  end

  def update?
    case record.permission
    when 'added_by_admin'
      user.admin?
    when 'added_by_manager'
      (person.managed_teams.include?(record.team)) || user.admin
    when 'added_by_current_member'
      (person.teams.include?(record.team)) || user.admin
    when 'has_account'
      true
    end
  end

  def edit?
    (person.managed_teams.include?(record.team) && !record.permission == 'added_by_admin') || user.admin
  end

  def destroy?
    edit?
  end
end
