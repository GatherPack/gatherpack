class MailboxPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: MailboxAssignment.where(target: person).or(MailboxAssignment.where(target: person.all_teams)).map(&:mailbox_id))
      end
    end
  end

  def create?
    user.admin?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
