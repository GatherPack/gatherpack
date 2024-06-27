class EventPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: user.event_ids)
      end
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
    user.admin || user.teams.includes?(record.team)
  end
end
