class Relationship < ApplicationRecord
  belongs_to :relationship_type
  belongs_to :parent, class_name: :Person
  belongs_to :child, class_name: :Person

  validate :no_self_relationships
  validate :permission_check

  attr_accessor :start_node, :node_occupant, :created_by

  def reify
    raise ArgumentError unless start_node.present? && node_occupant.present?
    
    type_id, side = start_node.split(':')
    self.relationship_type = RelationshipType.find(type_id)
    
    if side == 'p'
      self.parent = node_occupant
    elsif side == 'c'
      self.child = node_occupant
    else
      raise ArgumentError
    end
  end

  private

  def no_self_relationships
    errors.add(:parent, "cannot be the same person as the child") if parent != nil && parent == child
  end

  def permission_check
    binding.irb
    errors.add(:parent, 'does not meet relationship requirements') unless case relationship_type.permission
    when 'added_by_admin'
      created_by.user.admin?
    when 'added_by_manager'
      (created_by.managed_teams & parent.teams).present? &&
        (created_by.managed_teams & child.teams).present?
    when 'added_by_team_member'
      (created_by.teams & parent.teams).present? &&
        (created_by.teams & child.teams).present?
    when 'added_by_participant'
      created_by == parent || created_by == child
    when 'added_by_user'
      true
    end
  end
end
