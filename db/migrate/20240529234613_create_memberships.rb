class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships, id: KeyTypePicker.key_type do |t|
      t.references :person, null: false, foreign_key: true, type: KeyTypePicker.key_type
      t.references :team, null: false, foreign_key: true, type: KeyTypePicker.key_type

      t.timestamps
    end
  end
end
