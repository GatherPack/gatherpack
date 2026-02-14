class BudgetPeriodPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.teams)
      end
    end
  end

  def create?
    person.user.admin || person.manager?
  end

  def update?
    person.user.admin || person.manager_of?(record.team)
  end
end
