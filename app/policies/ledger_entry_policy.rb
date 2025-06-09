class LedgerEntryPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.includes(:ledger).where('ledger.team': person.teams)
      end
    end
  end

  def split?
    update?
  end

  def unsplit?
    update?
  end

  def create?
    person.admin? || record.ledger.team.managers.include?(person)
  end

  def update?
    person.admin? || record.ledger.team.managers.include?(person)
  end

  def destroy?
    person.admin? || record.ledger.team.managers.include?(person)
  end
end
