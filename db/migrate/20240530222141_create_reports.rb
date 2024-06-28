class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports, id: KeyTypePicker.key_type do |t|
      t.string :name
      t.text :code

      t.timestamps
    end
  end
end
