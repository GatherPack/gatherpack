class TokenPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      elsif person.manager?
        scope.where(tokenable: (person.all_managed_teams.map(&:person_ids).flatten << person.id).uniq)
      else
        scope.where(tokenable: person)
      end
    end
  end

  def create?
    user.admin? || person.manager?
  end

  def edit?
    create?
  end
end
