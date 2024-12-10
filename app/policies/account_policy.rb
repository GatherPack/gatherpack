class AccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(id: person.accounts.pluck(:id)).or(scope.where(team: person.managed_teams))
      end
    end
  end

  def show?
    user.admin || person.managed_teams.include?(record.team) || record&.holders&.include?(person)
  end

  def new?
    user.admin || person.manager?
  end

  def create?
    update?
  end

  def update?
    user.admin || person.managed_teams.include?(record.team) 
  end

  def destroy?
    create?
  end
end
