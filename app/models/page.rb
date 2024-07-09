class Page < ApplicationRecord
  belongs_to :team, optional: true

  PERMISSION_LEVELS = %w[ public user team manager admin ]

  validates :viewer, inclusion: { in: PERMISSION_LEVELS }
  validates :editor, inclusion: { in: PERMISSION_LEVELS }
  validates :editor, inclusion: { in: ['admin'], message: 'must be restricted to admins when enabling ERB parsing'}, if: -> { dynamic == true }
  validate :manager_editor_needs_team
  validate :manager_viewer_needs_team

  def self.ransackable_attributes(auth_object = nil)
    [ 'content', 'title', 'team_id' ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ 'team' ]
  end

  private

  def manager_editor_needs_team
    errors.add(:editor, "can't be 'manager' if there's no team") if editor == 'manager' && team.nil?
  end

  def manager_viewer_needs_team
    errors.add(:viewer, "can't be 'manager' if there's no team") if viewer == 'manager' && team.nil?
  end
end
