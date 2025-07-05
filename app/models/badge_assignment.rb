class BadgeAssignment < ApplicationRecord
  has_neat_id :bda
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :badge
  belongs_to :person

  validate :team_membership

  private

  def team_membership
    errors.add(:person, " must be a member of the badge's team") if badge.team.present? && !person.teams.include?(badge.team)
  end
end
