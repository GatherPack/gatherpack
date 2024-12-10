class Relationship < ApplicationRecord
  belongs_to :relationship_type
  belongs_to :parent, class_name: :Person
  belongs_to :child, class_name: :Person

  validate :no_self_relationships

  attr_accessor :start_node, :node_occupant

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
end
