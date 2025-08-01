class LedgerPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.includes(:ledger_ownerships).where(team: person.teams).or(scope.where('ledger_ownerships.owner_id': person.id, 'ledger_ownerships.owner_type': person.class.name))
      end
    end
  end

  def split?
    update?
  end

  def unsplit?
    update?
  end

  def pay?
    person.admin? || record.team.all_managers.include?(person) || record.owners.include?(person)
  end

  def create?
    person.manager?
  end

  def update?
    person.admin? || record.team.all_managers_and_admins.include?(person)
  end

  def destroy?
    person.admin? || record.team.all_managers_and_admins.include?(person)
  end
end
