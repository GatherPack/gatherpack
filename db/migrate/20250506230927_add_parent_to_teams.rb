class AddParentToTeams < ActiveRecord::Migration[8.0]
  def change
    add_reference :teams, :parent, null: true, foreign_key: { to_table: :teams }, type: :uuid, index: true
  end
end
