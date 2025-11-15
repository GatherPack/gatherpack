class BadgeAssignment < ApplicationRecord
  has_neat_id :bda
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :badge
  belongs_to :person

  validate :team_membership

  def identifier_name
    "#{person.display_name} => #{badge.name}"
  end

  private

  def team_membership
    return true unless badge.present? && badge.team.present?
    errors.add(:person, " must be a member of the badge's team") unless person.all_teams.include?(badge.team)
  end
end
