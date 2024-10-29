class RelationshipType < ApplicationRecord
  has_many :relationships
  PERMISSION_LEVELS = %w[ parent child user team manager admin ]

  def self.ransackable_attributes(auth_object = nil)
    [ 'parent_label', 'child_label' ]
  end

  def identifier_name
    "#{parent_label} - #{child_label}"
  end
end
