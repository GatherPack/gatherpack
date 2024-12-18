class AddPermissionToBadge < ActiveRecord::Migration[8.0]
  def change
    add_column :badges, :permission, :integer
  end
end
