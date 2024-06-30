class Team < ApplicationRecord
  belongs_to :team_type
  has_many :announcements
  has_many :memberships
  has_many :people, through: :memberships
  has_many :events

  def self.ransackable_attributes(auth_object = nil)
    ['name', 'team_type_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['team_type']
  end
end
