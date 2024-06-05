class TeamType < ApplicationRecord
  has_many :teams

  def self.ransackable_attributes(auth_object = nil)
    ['icon', 'name']
  end
end
