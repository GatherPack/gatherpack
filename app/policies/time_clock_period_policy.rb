class TimeClockPeriodPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.all_teams).or(scope.where(team: nil))
      end
    end
  end

  def create?
    user.admin || person.manager?
  end

  def update?
    user.admin || (record.team.nil? ? false : person.all_managed_teams.include?(record.team))
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
