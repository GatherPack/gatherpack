class TimeClockPeriod < ApplicationRecord
  has_neat_id :tcpd
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team, optional: true
  has_many :time_clock_punches, dependent: :destroy
  has_many :events, dependent: :nullify
  enum :permission, added_by_admin: 0, added_by_manager: 1, added_by_team_member: 2, added_by_user: 3

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :valid_times, :permissions_make_sense

  def self.ransackable_attributes(auth_object = nil)
    %w[ name team_id start_time end_time updated_at ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[ team ]
  end

  def identifier_name
    "#{name} (#{start_time.strftime("%Y-%m-%d")} - #{end_time.strftime("%Y-%m-%d")})"
  end

  def identifier_icon
    "hourglass"
  end

  def available_hours
    self.events.where(start_time: start_time..end_time, end_time: start_time..end_time).where('end_time < ?', Time.now).map(&:hours).sum
  end

  def total_hours
    self.events.where(start_time: start_time..end_time, end_time: start_time..end_time).map(&:hours).sum
  end

  def open_punches
    self.time_clock_punches.where(end_time: nil)
  end

  private

  def valid_times
    if start_time.present? && end_time.present?
      errors.add(:end_time, "cannot be before start time") if end_time.before? start_time
    end
  end

  def permissions_make_sense
    errors.add(:team_id, "can't be empty if \"team\" managers can add punches to this period") if team.nil? && permission == "added_by_manager"
    errors.add(:team_id, "can't be empty if \"team\" members can add punches to this period") if team.nil? && permission == "added_by_team_member"
    errors.add(:team_id, "can't be associated with a period that contains non-team member punches in this period (unlink them first)") if team.present? && TimeClockPunch.all.where(time_clock_period: self).any? { |punch| punch.person.teams.exclude? team }
  end
end
