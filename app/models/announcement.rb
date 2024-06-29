class Announcement < ApplicationRecord
  belongs_to :team, optional: true

  scope :visible, -> { where("start_time < ?", DateTime.now).and(where("end_time > ?", DateTime.now)) }

  def self.ransackable_attributes(auth_object = nil)
    ['title', 'content', 'start_time', 'end_time', 'team_id']
  end

  def self.ransackable_associations(auth_objects = nil)
    ['team']
  end
end
