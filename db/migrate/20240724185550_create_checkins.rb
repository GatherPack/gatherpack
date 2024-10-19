class CreateCheckins < ActiveRecord::Migration[8.0]
  def change
    create_table :checkins, id: KeyTypePicker.key_type do |t|
      t.string :notes
      t.references :person, null: false, foreign_key: true, type: :string
      t.references :event, null: false, foreign_key: true, type: :string

      t.timestamps
    end
  end
end
