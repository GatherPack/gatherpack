class CreateBudgetPeriods < ActiveRecord::Migration[8.1]
  def change
    create_table :budget_periods, id: :uuid do |t|
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :team, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
