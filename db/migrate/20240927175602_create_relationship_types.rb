class CreateRelationshipTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :relationship_types, id: KeyTypePicker.key_type do |t|
      t.string :parent_label
      t.string :child_label
      t.string :permission

      t.timestamps
    end
  end
end
