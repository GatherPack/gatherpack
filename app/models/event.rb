class Event < ApplicationRecord
  belongs_to :event_type
  belongs_to :team, optional: true

  def self.ransackable_attributes(auth_object = nil)
    ['name', 'start_time', 'end_time', 'location', 'event_type_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['event_type']
  end

  validate :valid_times

  private
  def valid_times
    errors.add(:end_time, "Your event cannot end before it starts!") if end_time.before?(start_time)
  end
end
