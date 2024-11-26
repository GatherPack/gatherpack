class BadgePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.teams).or(scope.where(team_id: ""))
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
    person.managed_teams.include?(record.team) || user.admin
  end
end
