class CreateCheckinFields < ActiveRecord::Migration[8.0]
  def change
    create_table :checkin_fields, id: :uuid do |t|
      t.references :event_type, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.integer :permission, default: 0, null: false

      t.timestamps
    end
  end
end
