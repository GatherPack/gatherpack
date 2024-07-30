class AddJoinPermissionToTeam < ActiveRecord::Migration[8.0]
  def change
    change_table :teams do |t|
      t.column :join_permission, :integer, default: 0
    end
  end
end
