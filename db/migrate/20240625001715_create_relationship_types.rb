class CreateRelationshipTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :relationship_types, id: :uuid do |t|
      t.string :name
      t.string :parent_label
      t.string :child_label

      t.timestamps
    end
  end
end
