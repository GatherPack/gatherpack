class AddUniqueIndexToCheckins < ActiveRecord::Migration[8.1]
  def up
    # Keep the oldest checkin for each event/person pair. Duplicates' field
    # responses go with them.
    execute <<~SQL
      CREATE TEMPORARY TABLE duplicate_checkins ON COMMIT DROP AS
      SELECT id FROM (
        SELECT id, ROW_NUMBER() OVER (PARTITION BY event_id, person_id ORDER BY created_at, id) AS row_number
        FROM checkins
      ) ranked
      WHERE row_number > 1
    SQL
    execute "DELETE FROM checkin_field_responses WHERE checkin_id IN (SELECT id FROM duplicate_checkins)"
    execute "DELETE FROM checkins WHERE id IN (SELECT id FROM duplicate_checkins)"

    add_index :checkins, %i[event_id person_id], unique: true
  end

  def down
    remove_index :checkins, %i[event_id person_id]
  end
end
