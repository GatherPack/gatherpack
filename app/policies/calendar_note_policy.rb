class CalendarNotePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(noteable: (person.all_teams.map(&:person_ids).flatten << person.id).uniq).or(scope.where(noteable: person.all_teams)).or(scope.where(noteable: nil))
      end
    end
  end
end
