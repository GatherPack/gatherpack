class Membership < ApplicationRecord
  include CanBeHooked
  belongs_to :person
  belongs_to :team

  def self.ransackable_attributes(auth_object = nil)
    [ 'manager', 'person.display_name' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'person' ]
  end
end
