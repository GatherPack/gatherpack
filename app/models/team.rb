class Team < ApplicationRecord
  belongs_to :team_type
  has_many :memberships
  has_many :people, through: :memberships

  def self.ransackable_attributes(auth_object = nil)
    ['name', 'team_type_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['team_type']
  end
end
