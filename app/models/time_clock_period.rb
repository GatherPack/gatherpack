class TimeClockPeriod < ApplicationRecord
  belongs_to :team, optional: true
  enum :permission, added_by_admin: 0, added_by_manager: 1, added_by_team_member: 2, added_by_user: 3

  validate :valid_times, :permissions_make_sense

  def self.ransackable_attributes(auth_object = nil)
    %w[ name team_id start_time end_time ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ team ]
  end

  private

  def valid_times
    if start_time.present? && end_time.present?
      errors.add(:end_time, 'cannot be before start time') if end_time.before? start_time
    end
  end

  def permissions_make_sense
    errors.add(:team, "can't be empty if \"team\" managers can add punches to this period") if team.nil? && permission == 'added_by_manager'
    errors.add(:team, "can't be empty if \"team\" members can add punches to this period") if team.nil? && permission == 'added_by_team_member'
    errors.add(:team, "can't be associated with a period that contains non-team member punches in this period (unlink them first)") if team.present? && TimeClockPunch.all.where(time_clock_period: self).any? { |punch| punch.person.teams.exclude? team }
  end
end
