class CreateTimeClockPeriods < ActiveRecord::Migration[8.0]
  def change
    create_table :time_clock_periods, id: :uuid do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.integer :permission, default: 0, null: false
      t.references :team, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
