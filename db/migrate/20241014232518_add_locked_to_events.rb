class AddLockedToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :locked, :boolean
  end
end
