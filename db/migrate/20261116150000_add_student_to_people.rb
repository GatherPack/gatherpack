class AddStudentToPeople < ActiveRecord::Migration[8.1]
  def change
    add_column :people, :student, :boolean, default: false, null: false
  end
end
