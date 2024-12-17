class TimeClockPunchPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      elsif person.managed_teams.present?
        scope.where(person: (person.managed_teams.map(&:person_ids).flatten << person.id).uniq)
      else
        scope.where(person: person)
      end
    end
  end
end
