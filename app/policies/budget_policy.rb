class BudgetPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.includes(:budget_period).where('budget_periods.team': person.teams)
      end
    end
  end

  def create?
    person.user.admin || person.manager?
  end
end
