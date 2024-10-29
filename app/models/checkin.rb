class Checkin < ApplicationRecord
  belongs_to :person
  belongs_to :event

  validates :person, presence: true
  
  def self.ransackable_attributes(auth_object = nil)
    ['person.display_name']
  end

  def self.ransackable_associations(auth_object = nil)
    ['person']
  end
end
