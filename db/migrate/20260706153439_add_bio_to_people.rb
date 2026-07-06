class AddBioToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :bio, :text
  end
end
