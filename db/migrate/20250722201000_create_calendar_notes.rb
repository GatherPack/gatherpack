class CreateCalendarNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :calendar_notes, id: :uuid do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.references :noteable, polymorphic: true, type: :uuid

      t.timestamps
    end
  end
end
