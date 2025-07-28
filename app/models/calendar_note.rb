class CalendarNote < ApplicationRecord
  has_neat_id :cnote
  belongs_to :noteable, polymorphic: true, optional: true

  validates :name, presence: true
  validates :start_time, presence: true

  validate :valid_times

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "description", "start_time", "end_time", "noteable_type", "noteable_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "noteable" ]
  end

  private

  def valid_times
    if start_time? && end_time? then
      errors.add(:end_time, "cannot be before start time!") if end_time.before?(start_time)
    end
  end
end
