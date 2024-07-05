class Team < ApplicationRecord
  belongs_to :team_type
  has_many :announcements
  has_many :memberships
  has_many :people, through: :memberships
  has_many :events
  enum :join_permission, { added_by_admin: 0, added_by_manager: 1, added_by_current_member: 2, has_account: 3 }

  validates :name, presence: true
  validates :join_permission, inclusion: { in: join_permissions.keys }

  def self.ransackable_attributes(auth_object = nil)
    ['name', 'team_type_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['team_type']
  end
end
