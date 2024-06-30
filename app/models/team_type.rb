class TeamType < ApplicationRecord
  has_many :teams
  validates :name, presence: true
  validates :icon, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['icon', 'name']
  end
end
