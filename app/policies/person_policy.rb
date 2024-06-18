class PersonPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: (person.teams.map(&:person_ids).flatten << person.id)).distinct
      end
    end
  end
end
