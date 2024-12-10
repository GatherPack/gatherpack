class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name
      t.string :color
      t.references :team_type, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
