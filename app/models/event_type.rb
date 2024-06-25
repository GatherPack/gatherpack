class EventType < ApplicationRecord
  has_many :events

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end
end
