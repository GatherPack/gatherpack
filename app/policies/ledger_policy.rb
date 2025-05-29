class LedgerPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.includes(:ledger_ownerships).where(team: person.teams).or(scope.where('ledger_ownerships.owner': person))
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
    person.manager?
  end

  def update?
    person.admin? || record.team.all_managers.include?(person)
  end

  def destroy?
    person.admin? || record.team.all_managers.include?(person)
  end
end
