class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions, id: KeyTypePicker.key_type do |t|
      t.string :comment
      t.integer :amount_cents
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.references :created_by, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
