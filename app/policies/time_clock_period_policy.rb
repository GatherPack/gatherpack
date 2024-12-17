class TimeClockPeriodPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        if person.managed_teams.present?
          scope.where(team: person.managed_teams, permission: 'added_by_manager')
        else
          scope.where(team: person.teams, permission: 'added_by_team_member').or(scope.where(permission: 'added_by_user'))
        end
      end
    end

    def create?
      user.admin? || person.managed_teams.present?
    end
  end
end
