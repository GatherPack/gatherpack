class AddManagerToMemberships < ActiveRecord::Migration[8.0]
  def change
    add_column :memberships, :manager, :boolean, default: false
  end
end
