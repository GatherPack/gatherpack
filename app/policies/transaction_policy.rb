class TransactionPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      elsif person.manager?
        scope.includes(:account).where('account.team': person.managed_teams).or(scope.where(account_id: person.accounts.pluck(:id)))
      else
        scope.includes(:account).where('account.team': person.teams).or(scope.where(account_id: person.accounts.pluck(:id)))
      end
    end
  end

  def new?
    user.admin? || record.is_a?(Transaction) && record&.account&.team&.managers&.include?(person)
  end

  def create?
    user.admin? || record&.account&.team&.managers&.include?(person)
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
