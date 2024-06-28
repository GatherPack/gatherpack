class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events, id: KeyTypePicker.key_type do |t|
      t.text :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.references :event_type, null: false, foreign_key: true, type: KeyTypePicker.key_type
      t.references :team, null: true, type: KeyTypePicker.key_type #do not need to have a team for an event

      t.timestamps
    end
  end
end
