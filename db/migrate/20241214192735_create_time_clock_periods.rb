class CreateTimeClockPeriods < ActiveRecord::Migration[8.0]
  def change
    create_table :time_clock_periods, id: :uuid do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :permission
      t.references :team, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
