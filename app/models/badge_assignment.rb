class BadgeAssignment < ApplicationRecord
  has_neat_id :bda
  include CanBeHooked
  belongs_to :badge
  belongs_to :person

  validate :team_membership

  private

  def team_membership
    errors.add(:person, " must be a member of the badge's team") if badge.team.present? && !person.teams.include?(badge.team)
  end
end
