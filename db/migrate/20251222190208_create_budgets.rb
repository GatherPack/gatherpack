class CreateBudgets < ActiveRecord::Migration[8.1]
  def change
    create_table :budgets, id: :uuid do |t|
      t.integer :amount_cents
      t.references :budget_period, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
