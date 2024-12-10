class Team < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team_type
  has_many :announcements
  has_many :badges
  has_many :events
  has_many :memberships, dependent: :destroy
  has_many :people, through: :memberships
  has_many :events
  has_many :pages
  enum :join_permission, { added_by_admin: 0, added_by_manager: 1, added_by_current_member: 2, has_account: 3 }

  validates :name, presence: true
  validates :join_permission, inclusion: { in: join_permissions.keys }

  def self.ransackable_attributes(auth_object = nil)
    [ 'name', 'team_type_id' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'team_type' ]
  end

  def managers
    people.joins(:memberships).where(memberships: { manager: true })
  end
end
