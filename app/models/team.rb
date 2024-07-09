class Team < ApplicationRecord
  belongs_to :team_type
  has_many :announcements
  has_many :badges
  has_many :events
  has_many :memberships
  has_many :people, through: :memberships
  has_many :events
  has_many :pages

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['name', 'team_type_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['team_type']
  end

  def managers
    people.joins(:memberships).where(memberships: { manager: true })
  end
end
