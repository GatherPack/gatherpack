class Badge < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: 'AuditLog' }
  belongs_to :badge_type
  belongs_to :team, optional: true
  has_many :badge_assignments, dependent: :destroy
  has_many :people, through: :badge_assignments
  enum :permission, { added_by_admin: 0, added_by_manager: 1, added_by_current_member: 2, has_account: 3, added_by_manager_or_self: 4, added_by_admin_or_self: 5 }

  validates :name, presence: true
  validates :color, presence: true
  validates :short, presence: true
  validates :badge_type, presence: true
  validate :permissions_make_sense

  def self.ransackable_attributes(auth_object = nil)
    [ 'badge_type_id', 'description', 'name', 'short', 'team_id' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'badge_type', 'team' ]
  end

  def permissions_make_sense
    errors.add(:permission, "can't be 'Added by Manager' if there's no team") if permission == 'added_by_manager' && team.nil?
    errors.add(:permission, "can't be 'Added by Current Member' if there's no team") if permission == 'added_by_current_member' && team.nil?
  end
end
