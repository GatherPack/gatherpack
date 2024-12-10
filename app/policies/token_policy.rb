class TokenPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
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
