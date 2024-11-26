class AnnouncementPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team_id: person.teams.map(&:id)).or(scope.where(team_id: ""))
      end
    end
  end

  def create?
    user.admin || person.manager?
  end

  def update?
    user.admin || (record.team && person.managed_teams.include?(record.team))
  end
end
