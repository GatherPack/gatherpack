class AddUniqueIndexToBadgeAssignments < ActiveRecord::Migration[8.1]
  def up
    # Keep the oldest assignment for each badge/person pair.
    execute <<~SQL
      DELETE FROM badge_assignments
      WHERE id IN (
        SELECT id FROM (
          SELECT id, ROW_NUMBER() OVER (PARTITION BY badge_id, person_id ORDER BY created_at, id) AS row_number
          FROM badge_assignments
        ) ranked
        WHERE row_number > 1
      )
    SQL

    add_index :badge_assignments, %i[badge_id person_id], unique: true
  end

  def down
    remove_index :badge_assignments, %i[badge_id person_id]
  end
end
