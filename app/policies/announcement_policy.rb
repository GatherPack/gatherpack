class AnnouncementPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin
        scope.all
      else
        scope.where(team_id: person.all_teams.map(&:id)).or(scope.where(team_id: "").or(scope.where(team_id: nil)))
      end
    end
  end

  def new?
    user.admin? || manageable_teams.present?
  end

  def create?
    user.admin? || manageable_teams.include?(record.team)
  end

  def update?
    create?
  end

  private

  # An announcement with no team goes to every person in the system
  # (see AnnouncementNotificationRouter), so for everyone but an admin it has
  # to name a team they actually manage.
  def manageable_teams
    person&.all_managed_teams || Team.none
  end
end
