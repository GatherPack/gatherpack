class CreateShortcuts < ActiveRecord::Migration[8.0]
  def change
    create_table :shortcuts, id: :uuid do |t|
      t.string :name
      t.string :target
      t.string :icon
      t.string :color
      t.references :team, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
