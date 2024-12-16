class TimeClockPunch < ApplicationRecord
  belongs_to :person
  belongs_to :time_clock_period, optional: true

  validates :start_time, presence: true
  validates :end_time, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[ person_display_name start_time end_time time_clock_period_id ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ person time_clock_period ]
  end
end
