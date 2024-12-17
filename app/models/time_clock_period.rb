class TimeClockPeriod < ApplicationRecord
  belongs_to :team, optional: true
  enum :permission, added_by_admin: 0, added_by_manager: 1, added_by_team_member: 2, added_by_user: 3

  validate :valid_times

  def self.ransackable_attributes(auth_object = nil)
    %w[ team_id start_time end_time ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ team ]
  end

  private
  def valid_times
    if start_time? && end_time? then
      errors.add(:end_time, 'cannot be before start time!') if end_time.before?(start_time)
    end
  end
end
