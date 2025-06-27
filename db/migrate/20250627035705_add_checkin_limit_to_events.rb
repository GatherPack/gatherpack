class AddCheckinLimitToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :checkin_limit, :integer, null: true
  end
end
