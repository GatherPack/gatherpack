class EventPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team_id: person.all_teams.map(&:id)).or(scope.where(team_id: ""))
      end
    end
  end

  def new?
    person.all_managed_teams.present? || user.admin
  end

  def create?
    person.all_managed_teams.include?(record.team) || user.admin
  end

  def update?
    person.all_managed_teams.include?(record.team) || user.admin
  end
end
