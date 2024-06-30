class AnnouncementPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team_id: person.teams.map(&:id)).or(scope.where(team_id: ""))
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
    user.admin || person.teams.include?(record.team)
  end
end
