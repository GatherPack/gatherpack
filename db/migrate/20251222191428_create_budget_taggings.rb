class CreateBudgetTaggings < ActiveRecord::Migration[8.1]
  def change
    create_table :budget_taggings, id: :uuid do |t|
      t.references :budget, null: false, foreign_key: true, type: :uuid
      t.references :ledger_tag, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
