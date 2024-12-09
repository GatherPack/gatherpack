class CreateVariables < ActiveRecord::Migration[8.0]
  def change
    create_table :variables, id: :uuid do |t|
      t.string :name
      t.string :klass
      t.text :raw_value

      t.timestamps
    end
  end
end
