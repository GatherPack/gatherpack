class CheckinPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def create?
    !record.event.locked? || user.admin || (record.event.team && record.event.team.manager?(person))
  end

  def new?
    create?
  end

  def update?
    record.person == person || user.admin || (record.event.team && record.event.team.manager?(person))
  end
end
