class AddEarnedAtToBadgeAssignments < ActiveRecord::Migration[8.1]
  def up
    add_column :badge_assignments, :earned_at, :datetime
    execute "UPDATE badge_assignments SET earned_at = created_at WHERE earned_at IS NULL"
  end

  def down
    remove_column :badge_assignments, :earned_at
  end
end
