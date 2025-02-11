class AddTimeClockPeriodRefToEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :time_clock_period, null: true, foreign_key: true, type: :uuid
  end
end
