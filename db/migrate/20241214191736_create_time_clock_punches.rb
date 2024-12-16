class CreateTimeClockPunches < ActiveRecord::Migration[8.0]
  def change
    create_table :time_clock_punches, id: :uuid do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :note
      t.references :person, null: false, foreign_key: true, type: :uuid
      t.references :time_clock_period, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
