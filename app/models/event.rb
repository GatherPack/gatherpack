class Event < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :event_type
  belongs_to :team, optional: true
  belongs_to :time_clock_period, optional: true

  has_many :checkins

  validates :name, presence: true
  validates :start_time, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "name", "start_time", "end_time", "location", "event_type_id", "team_id", "time_clock_period_id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "event_type", "team", "time_clock_period" ]
  end

  validate :valid_times

  def hours
    ((self.end_time - self.start_time) / 3600 * 20).round / 20.0
  end

  def identifier_icon
    "calendar"
  end

  private

  def valid_times
    if start_time? && end_time? then
      errors.add(:end_time, "cannot be before start time!") if end_time.before?(start_time)
    end
  end
end
