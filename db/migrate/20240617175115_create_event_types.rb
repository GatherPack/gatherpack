class CreateEventTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :event_types, id: KeyTypePicker.key_type do |t|
      t.string :name

      t.timestamps
    end
  end
end
