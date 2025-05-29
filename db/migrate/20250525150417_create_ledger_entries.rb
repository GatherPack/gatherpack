class CreateLedgerEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :ledger_entries, id: :uuid do |t|
      t.references :ledger, null: false, foreign_key: true, type: :uuid
      t.string :remark
      t.integer :amount_cents, default: 0
      t.references :created_by, polymorphic: true, null: false, type: :uuid
      t.boolean :approved

      t.timestamps
    end
  end
end
