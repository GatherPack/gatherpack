class LedgerPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.teams).or(scope.where(team_id: ""))
      end
    end
  end

  def create?
    person.manager?
  end

  def update?
    person.admin? || record.team.managers.include?(person)
  end

  def destroy?
    person.admin? || record.team.managers.include?(person)
  end
end
