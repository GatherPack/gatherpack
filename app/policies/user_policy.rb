class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def update?
    record == person || user.admin? || (person.all_managed_teams & record.all_teams).any?
  end

  def destroy?
    user.admin?
  end
end
