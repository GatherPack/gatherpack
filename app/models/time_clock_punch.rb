class TimeClockPunch < ApplicationRecord
  belongs_to :person
  belongs_to :time_clock_period, optional: true

  validate :permission_check
  validate :valid_times

  validates :start_time, presence: true
  validates :end_time, presence: true

  attr_accessor :created_by

  def self.ransackable_attributes(auth_object = nil)
    %w[ person_display_name start_time end_time time_clock_period_id ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ person time_clock_period ]
  end

  def permission_check
    true if :time_clock_period.nil?
    errors.tap do |t|
      t.add(:time_clock_period, 'does not meet permission requirements')
    end unless case time_clock_period.permission
               when 'added_by_admin'
                 created_by.user.admin?
               when 'added_by_manager'
                 created_by.managed_teams.include? time_clock_period.team
               when 'added_by_team_member'
                 created_by.teams.include? time_clock_period.team
               when 'added_by_user'
                 true
               end
  end

  private
  def valid_times
    if start_time? && end_time? then
      errors.add(:end_time, 'cannot be before start time!') if end_time.before?(start_time)
    end
  end
end