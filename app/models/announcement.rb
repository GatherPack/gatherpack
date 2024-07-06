class Announcement < ApplicationRecord
  includes Hookable
  belongs_to :team, optional: true

  validates :title, presence: true
  validates :content, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  scope :visible, -> { where('start_time < ? AND end_time > ?', DateTime.now, DateTime.now) }

  def self.ransackable_attributes(auth_object = nil)
    ['title', 'content', 'start_time', 'end_time', 'team_id']
  end

  def self.ransackable_associations(auth_objects = nil)
    ['team']
  end
end
