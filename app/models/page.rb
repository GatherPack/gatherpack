class Page < ApplicationRecord
  belongs_to :team, optional: true

  PERMISSION_LEVELS = %w[ public user team manager admin ]

  validates :title, presence: true
  validates :content, presence: true
  validates :viewer, inclusion: { in: PERMISSION_LEVELS }
  validates :editor, inclusion: { in: PERMISSION_LEVELS }
  validates :editor, inclusion: { in: [ 'admin' ], message: 'must be restricted to admins when enabling ERB parsing' }, if: -> { dynamic == true }
  validate :manager_permission_needs_team
  validate :permission_hierarchy

  def self.ransackable_attributes(auth_object = nil)
    [ 'content', 'title', 'team_id' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'team' ]
  end

  private

  def manager_permission_needs_team
    errors.add(:editor, "can't be 'manager' if there's no team") if editor == 'manager' && team.nil?
    errors.add(:viewer, "can't be 'manager' if there's no team") if viewer == 'manager' && team.nil?
  end

  def permission_hierarchy
    errors.add(:viewer, "can't be higher than the editor permission") if PERMISSION_LEVELS.find_index(editor) < PERMISSION_LEVELS.find_index(viewer)
  end
end
