class RelationshipType < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ['name', 'parent_label', 'child_label']
  end
end
