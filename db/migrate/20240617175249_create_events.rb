class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events, id: :uuid do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.references :event_type, null: false, foreign_key: true, type: :uuid
      t.references :team, null: true, foreign_key: false, type: :uuid

      t.timestamps
    end
  end
end
