class MailboxMessagePolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(mailbox_id: MailboxAssignment.where(target: person).or(MailboxAssignment.where(target: person.teams)).map(&:mailbox_id))
      end
    end
  end

  def create?
    false
  end

  def update?
    false
  end

  def show?
    user.admin? ||
    record.mailbox.targets.include?(person) || 
      (record.mailbox.targets & person.teams).any? ||
      (record.mailbox.targets & person.events).any?
  end

  def destroy?
    show?
  end
end
