class CreateRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :relationships, id: KeyTypePicker.key_type do |t|
      t.references :relationship_type, null: false, foreign_key: true, type: :uuid
      t.references :parent, null: false, foreign_key: { to_table: :people }, type: :uuid
      t.references :child, null: false, foreign_key: { to_table: :people }, type: :uuid

      t.timestamps
    end
  end
end
