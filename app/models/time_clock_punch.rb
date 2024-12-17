class TimeClockPunch < ApplicationRecord
  belongs_to :person
  belongs_to :time_clock_period, optional: true

  validate :permission_check, :valid_times

  validates :start_time, presence: true

  attr_accessor :created_by

  def self.ransackable_attributes(auth_object = nil)
    %w[ person.display_name start_time end_time time_clock_period_id ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ person time_clock_period ]
  end

  def identifier_name
    unknown = 'Unknown'
    if end_time.present?
      "#{person.nil? ? unknown : person.display_name} - #{start_time.strftime('%m/%d/%Y %I:%M%p')} to #{end_time.strftime('%m/%d/%Y %I:%M%p')}"
    else
      "#{person.nil? ? unknown : person.display_name} - #{start_time.strftime('%m/%d/%Y %I:%M%p')} (Still clocked in)"
    end
  end

  private

  def permission_check
    if time_clock_period.nil?
      true
    else
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
  end

  def valid_times
    errors.add(:start_time, 'cannot start before period start time!') if time_clock_period.present? && start_time.before?(time_clock_period.start_time)
    if end_time.present?
      if end_time.before? start_time
        errors.add(:end_time, 'cannot end before start time!')
      elsif time_clock_period.present? && end_time.after?(time_clock_period.end_time)
        errors.add(:end_time, 'cannot end after period end time!')
      end
    end
  end
end
