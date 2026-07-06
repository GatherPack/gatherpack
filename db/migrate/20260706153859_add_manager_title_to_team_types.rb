class AddManagerTitleToTeamTypes < ActiveRecord::Migration[8.1]
  def change
    add_column :team_types, :manager_title, :string, default: "Manager", null: false
  end
end
