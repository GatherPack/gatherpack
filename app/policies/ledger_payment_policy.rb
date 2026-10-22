class LedgerPaymentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def create?
    record.ledger.present? && (person.manager? || record.ledger.owners.include?(person))
  end
end
