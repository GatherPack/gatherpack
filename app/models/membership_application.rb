class MembershipApplication < ApplicationRecord
  has_neat_id :ma
  include CanBeHooked

  has_paper_trail versions: { class_name: "AuditLog" }

  belongs_to :person
  belongs_to :team

  enum :status, { pending: 0, approved: 1, denied: 2 }

  validates :person, presence: true
  validates :team, presence: true
  validates :team_id, uniqueness: {
    scope: :person_id,
    message: "already have a pending application for this team"
  }, on: :create
  validate :team_requires_approval

  scope :pending, -> { where(status: :pending) }

  def approve!
    transaction do
      Membership.create!(person: person, team: team, manager: false)
      update!(status: :approved, reviewed_at: Time.current)
    end
  end

  def deny!
    update!(status: :denied, reviewed_at: Time.current)
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "status", "person_id", "team_id", "created_at", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "person", "team" ]
  end

  private

  def team_requires_approval
    return if team&.requires_approval?
    errors.add(:team, "does not require approval to join")
  end
end
