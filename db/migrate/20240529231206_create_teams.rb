class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams, id: KeyTypePicker.key_type do |t|
      t.string :name
      t.string :color
      t.references :team_type, null: false, foreign_key: true, type: KeyTypePicker.key_type

      t.timestamps
    end
  end
end
