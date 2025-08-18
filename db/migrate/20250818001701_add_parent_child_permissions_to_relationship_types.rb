class AddParentChildPermissionsToRelationshipTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :relationship_types, :parent_permissions, :string, array: true, default: []
    add_column :relationship_types, :child_permissions, :string, array: true, default: []
  end
end
