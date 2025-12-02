class BadgeAssignmentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def index?
    if record.is_a?(Badge)
      BadgePolicy.new(user, record).edit?
    else
      BadgePolicy.new(user, record.badge).edit?
    end
  end

  def show?
    BadgePolicy.new(user, record.badge).edit?
  end

  def create?
    BadgePolicy.new(user, record.badge).update?
  end

  def update?
    BadgePolicy.new(user, record.badge).update?
  end

  def destroy?
    BadgePolicy.new(user, record.badge).update?
  end
end
