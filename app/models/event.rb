class Event < ApplicationRecord
  include CanBeHooked
  has_paper_trail versions: { class_name: "Version" }
  belongs_to :event_type
  belongs_to :team, optional: true
  
  has_many :checkins

  validates :name, presence: true
  validates :start_time, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['name', 'start_time', 'end_time', 'location', 'event_type_id', 'team_id']
  end

  def self.ransackable_associations(auth_object = nil)
    ['event_type', 'team']
  end

  validate :valid_times

  private
  def valid_times
    if start_time? && end_time? then
      errors.add(:end_time, 'cannot be before start time!') if end_time.before?(start_time)
    end
  end
end
