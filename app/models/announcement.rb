class Announcement < ApplicationRecord
  has_neat_id :ann
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :team, optional: true

  attr_accessor :notify_now

  validates :title, presence: true
  validates :content, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  scope :visible, -> { where("start_time < ? AND end_time > ?", DateTime.current, DateTime.current) }

  def self.ransackable_attributes(auth_object = nil)
    [ "title", "content", "start_time", "end_time", "team_id", "updated_at" ]
  end

  def self.ransackable_associations(auth_objects = nil)
    [ "team" ]
  end

  def identifier_icon
    "comment"
  end
end
