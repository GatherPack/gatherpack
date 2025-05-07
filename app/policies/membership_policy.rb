class MembershipPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def new?
    has_perms
  end

  def update?
    has_perms
  end

  private
  def has_perms
    user.admin || record.team.manager?(user.person)
  end
end
