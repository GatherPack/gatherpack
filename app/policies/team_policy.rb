class TeamPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(id: person.team_ids)
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
    user.admin
  end
end
