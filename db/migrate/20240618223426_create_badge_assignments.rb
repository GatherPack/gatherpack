class CreateBadgeAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :badge_assignments, id: :uuid do |t|
      t.references :badge, null: false, foreign_key: true, type: :uuid
      t.references :person, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
