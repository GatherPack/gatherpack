class CreateBadges < ActiveRecord::Migration[8.0]
  def change
    create_table :badges, id: :uuid do |t|
      t.string :name
      t.text :description
      t.string :color
      t.string :short
      t.references :badge_type, null: false, foreign_key: true, type: :uuid
      t.references :team, null: true, foreign_key: false, type: :uuid

      t.timestamps
    end
  end
end
