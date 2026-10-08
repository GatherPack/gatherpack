class MembershipPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team_id: person.all_team_ids).or(scope.where(person_id: person.id))
      end
    end
  end

  def new?
    user.admin || user.person.manager?
  end

  # Managers add people to their teams. Anyone else may only join an open team
  # themselves, and never as a manager.
  def create?
    return true if user.admin || record.team&.manager?(person)

    record.person == person && !record.manager? && record.team&.has_account?
  end

  def update?
    user.admin || record.team.manager?(user.person)
  end
end
