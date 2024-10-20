class CreateAccountRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :account_relationships, id: KeyTypePicker.key_type do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.references :holder, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
