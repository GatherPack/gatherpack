class AddUniqueIndexToMemberships < ActiveRecord::Migration[8.1]
  def up
    # Keep one membership per team/person pair, preferring a manager one, then
    # the oldest.
    execute <<~SQL
      DELETE FROM memberships
      WHERE id IN (
        SELECT id FROM (
          SELECT id, ROW_NUMBER() OVER (
            PARTITION BY team_id, person_id
            ORDER BY manager DESC NULLS LAST, created_at, id
          ) AS row_number
          FROM memberships
        ) ranked
        WHERE row_number > 1
      )
    SQL

    add_index :memberships, %i[team_id person_id], unique: true
  end

  def down
    remove_index :memberships, %i[team_id person_id]
  end
end
