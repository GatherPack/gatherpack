class Announcement < ApplicationRecord
  belongs_to :team, optional: true

  def self.ransackable_attributes(auth_object = nil)
    ['title', 'content', 'start_time', 'end_time', 'team_id']
  end

  def self.ransackable_associations(auth_objects = nil)
    ['team']
  end

  def short(len = 20) #shorten the content of a really long announcement
    return 'This announcement has no content' unless content
    return content unless content.length > len
    content[0, len - 1] << '...'
  end
end
