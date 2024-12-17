class TimeClockPeriodPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        if person.manager?
          scope.where(team: person.managed_teams, permission: 'added_by_manager')
        else
          scope.where(team: person.teams, permission: 'added_by_team_member').or(scope.where(permission: 'added_by_user'))
        end
      end
    end

    def new?
      user.admin || person.manager?
    end
  end
end
