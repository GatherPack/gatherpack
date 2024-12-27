class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def update?
    record == user || user.admin?
  end

  def destroy?
    user.admin?
  end
end
