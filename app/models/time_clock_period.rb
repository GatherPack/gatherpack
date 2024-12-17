class TimeClockPeriod < ApplicationRecord
  belongs_to :team, optional: true
  enum :permission, added_by_admin: 0, added_by_manager: 1, added_by_team_member: 2, added_by_user: 3

  validate :valid_times, :permissions_make_sense

  def self.ransackable_attributes(auth_object = nil)
    %w[ team_id start_time end_time ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ team ]
  end

  private

  def valid_times
    if start_time.present? && end_time.present?
      errors.add(:end_time, 'cannot be before start time!') if end_time.before? start_time
    end
  end

  def permissions_make_sense
    errors.add(:team, "can't be empty if \"team\" managers can add punches to this period") if permission == 'added_by_manager' && team.nil?
    errors.add(:team, "can't be empty if \"team\" members can add punches to this period") if permission == 'added_by_team_member' && team.nil?
    errors.add(:team, "must be empty if any user can add punches to this period") if permission == 'added_by_user' && team.present?
  end
end
