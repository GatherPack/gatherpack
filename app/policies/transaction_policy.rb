class TransactionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.teams).or(scope.where(team_id: ''))
      end
    end
  end

  def new?
    user.admin? || person.manager?
  end

  def create?
    user.admin? || record.account.team.managers.include?(person)
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
