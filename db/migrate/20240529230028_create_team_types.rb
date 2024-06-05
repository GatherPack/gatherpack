class CreateTeamTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :team_types, id: :uuid do |t|
      t.string :name
      t.string :icon

      t.timestamps
    end
  end
end
