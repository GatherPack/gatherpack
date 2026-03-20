class TimeClockPunch < ApplicationRecord
  has_neat_id :tcp
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :person
  belongs_to :time_clock_period, optional: true

  validate :permission_check, :valid_times

  validates :start_time, presence: true

  attr_accessor :created_by

  TOO_LONG_HOURS = 12

  scope :too_long, -> {
    max_hours = (Settings[:time_clock_max_hours] || TOO_LONG_HOURS).to_i
    max_hours = TOO_LONG_HOURS unless max_hours > 0
    where.not(end_time: nil)
         .where("EXTRACT(EPOCH FROM (end_time - start_time)) > ?", max_hours * 3600)
  }

  scope :still_clocked_in, -> { where(end_time: nil) }

  def self.near_duplicates
    where(
      "id IN (
        SELECT DISTINCT p1.id FROM time_clock_punches p1
        JOIN time_clock_punches p2 ON p1.person_id = p2.person_id AND p1.id != p2.id
        WHERE p1.start_time < COALESCE(p2.end_time, 'infinity'::timestamptz)
          AND p2.start_time < COALESCE(p1.end_time, 'infinity'::timestamptz)
      )"
    )
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[ person.display_name start_time end_time time_clock_period_id updated_at ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ person time_clock_period ]
  end

  def identifier_name
    if end_time.present?
      "#{person.nil? ? 'Unknown' : person.display_name} - #{start_time.strftime('%m/%d/%Y %I:%M%p')} to #{end_time.strftime('%m/%d/%Y %I:%M%p')}"
    else
      "#{person.nil? ? 'Unknown' : person.display_name} - #{start_time.strftime('%m/%d/%Y %I:%M%p')} (Still clocked in)"
    end
  end

  def complete?
    start_time.present? && end_time.present?
  end

  def hours
    complete? ? ((self.end_time - self.start_time) / 3600 * 20).round / 20.0 : 0.0
  end

  def hours_so_far
    if complete?
      ((self.end_time - self.start_time) / 3600 * 20).round / 20.0
    else
      ((Time.current - self.start_time) / 3600 * 20).round / 20.0
    end
  end

  private

  def permission_check
    if time_clock_period.nil? || created_by == "kiosk"
      true
    else
      if time_clock_period.team.present?
        errors.add(:person_id, "is not a member of the team that the selected period is part of") unless person.all_teams.include? time_clock_period.team
      end
      valid = case time_clock_period.permission
      when "added_by_admin"
          created_by.user.admin?
      when "added_by_manager"
          created_by.all_managed_teams.include? time_clock_period.team
      when "added_by_team_member"
          created_by.all_teams.include? time_clock_period.team
      when "added_by_user"
          true
      end
      errors.add(:time_clock_period, "does not meet permission requirements") unless valid
    end
  end

  def valid_times
    errors.add(:start_time, "cannot start before period start time") if time_clock_period.present? && start_time.before?(time_clock_period.start_time)
    if end_time.present?
      if end_time.before? start_time
        errors.add(:end_time, "cannot end before start time")
      elsif time_clock_period.present? && end_time.after?(time_clock_period.end_time)
        errors.add(:end_time, "cannot end after period end time")
      end
    end
  end
end
