class BadgeAssignmentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end

  def create?
    (person.teams.include?(record.badge.team) && record.person.team.include?(record.badge.team)) || user.admin
  end

  def destroy?
    create?
  end
end
