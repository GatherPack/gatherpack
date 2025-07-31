class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def update?
    record == user || user.admin? || (person.all_managed_teams & (record&.person&.all_teams || [])).any?
  end

  def destroy?
    user.admin?
  end
end
