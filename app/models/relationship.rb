class Relationship < ApplicationRecord
  has_neat_id :rel
  include CanBeHooked
  has_paper_trail versions: { class_name: "AuditLog" }
  belongs_to :relationship_type
  belongs_to :parent, class_name: :Person
  belongs_to :child, class_name: :Person

  validate :no_self_relationships
  validate :permission_check

  attr_accessor :start_node, :node_occupant, :node_occupant_id, :other_occupant, :other_occupant_id, :created_by

  def reify
    raise ArgumentError unless start_node.present? && node_occupant.present?

    type_id, side = start_node.split(":")
    self.relationship_type = RelationshipType.find(type_id)

    if side == "p"
      self.parent = node_occupant
      self.child = other_occupant if other_occupant.present?
    elsif side == "c"
      self.child = node_occupant
      self.parent = other_occupant if other_occupant.present?
    else
      raise ArgumentError
    end
  end

  def node_occupant_id=(id)
    self.node_occupant = Person.find(id)
  end

  def other_occupant_id=(id)
    self.other_occupant = Person.find(id)
  end

  private

  def no_self_relationships
    if parent != nil && parent == child
      errors.add(:parent, "cannot be the same person as the child")
      errors.add(:child, "cannot be the same person as the parent")
    end
  end

  def permission_check
    errors.tap do |t|
       t.add(:parent, "does not meet relationship requirements")
       t.add(:child, "does not meet relationship requirements")
    end unless case relationship_type.permission
               when "added_by_admin"
      created_by.user.admin?
               when "added_by_manager"
      ((created_by.all_managed_teams & parent.teams).present? &&
        (created_by.all_managed_teams & child.teams).present?) || created_by.user.admin?
               when "added_by_team_member"
      ((created_by.teams & parent.teams).present? &&
        (created_by.teams & child.teams).present?) || created_by.user.admin?
               when "added_by_participant"
      created_by == parent || created_by == child || created_by.user.admin?
               when "added_by_user"
      true
               end
  end
end
