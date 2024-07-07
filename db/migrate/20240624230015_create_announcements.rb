class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements, id: :uuid do |t|
      t.string :title
      t.text :content
      t.datetime :start_time
      t.datetime :end_time
      t.references :team, null: true, type: :uuid

      t.timestamps
    end
  end
end
