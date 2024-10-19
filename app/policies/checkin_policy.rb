class CheckinPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def create?
    !record.event.locked
  end

  def new?
    true
  end

  def update?
    record.person == person || user.admin
  end
end