class CreateCheckins < ActiveRecord::Migration[8.0]
  def change
    create_table :checkins, id: :uuid do |t|
      t.string :notes
      t.references :person, null: false, foreign_key: true, type: :uuid
      t.references :event, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
