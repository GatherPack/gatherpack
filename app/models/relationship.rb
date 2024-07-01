class Relationship < ApplicationRecord
  belongs_to :relationship_type
  belongs_to :parent, class_name: 'Person'
  belongs_to :child, class_name: 'Person'

  validate :different_parent_and_child

  private
    def different_parent_and_child
      if parent.nil? or child.nil?
        return
      end

      if parent.id == child.id
        errors.add(:parent, 'and Child must be different')
        errors.add(:child, 'and Parent must be different')
      end
    end
end
