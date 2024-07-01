class RelationshipType < ApplicationRecord
  has_many :relationships
  belongs_to :team, optional: true

  def self.ransackable_attributes(auth_object = nil)
    ['name', 'parent_label', 'child_label']
  end
end
