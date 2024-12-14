class TimeClockPeriodPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team: person.teams).or(scope.where(team_id: ""))
      end
    end
  end
end
