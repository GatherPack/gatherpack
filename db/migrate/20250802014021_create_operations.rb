class CreateOperations < ActiveRecord::Migration[8.0]
  def change
    create_table :operations, id: :uuid do |t|
      t.string :name
      t.string :permission
      t.string :model
      t.string :scope
      t.string :icon
      t.string :color
      t.text :code
      t.text :view

      t.timestamps
    end
  end
end
