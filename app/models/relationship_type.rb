class RelationshipType < ApplicationRecord
  has_neat_id :rety
  has_paper_trail versions: { class_name: "AuditLog" }
  has_many :relationships
  enum :permission, added_by_admin: 0, added_by_manager: 1, added_by_team_member: 2, added_by_participant: 3, added_by_user: 4

  def self.ransackable_attributes(auth_object = nil)
    [ "parent_label", "child_label", "updated_at", "permission" ]
  end

  def identifier_name
    "#{parent_label} - #{child_label}"
  end
end
