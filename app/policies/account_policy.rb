class AccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      elsif person.manager?
        scope.where(team: person.teams)
      else
        scope.where(id: person.accounts.pluck(:id))
      end
    end
  end

  def show?
    user.admin || record&.team&.managers&.include?(person) || record&.holders&.include?(person)
  end

  def create?
    user.admin? || person.manager?
  end

  def update?
    user.admin || record&.team&.managers&.include?(user)
  end

  def destroy?
    create?
  end
end
