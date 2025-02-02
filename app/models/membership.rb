class Membership < ApplicationRecord
  include CanBeHooked
  belongs_to :person
  belongs_to :team, counter_cache: :person_count

  def self.ransackable_attributes(auth_object = nil)
    [ 'manager', 'person.display_name', 'person.last_name', 'person.first_name', 'person.birthday', 'updated_at' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'person' ]
  end
end
