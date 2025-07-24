class AddArchitectToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :architect, :boolean, default: false, null: false
  end
end
