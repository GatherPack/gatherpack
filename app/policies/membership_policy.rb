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

  def update?
    user.admin || record.team.manager?(user.person)
  end
end
