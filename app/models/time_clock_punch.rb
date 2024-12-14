class TimeClockPunch < ApplicationRecord
  belongs_to :person
  belongs_to :time_clock_period, :optional
end
