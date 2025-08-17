class AddDescriptionToTeams < ActiveRecord::Migration[8.0]
  def change
    add_column :teams, :description, :text
  end
end
