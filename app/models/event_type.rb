class EventType < ApplicationRecord
  has_many :events

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end
end
