class CreateLedgerEntryLinkings < ActiveRecord::Migration[8.0]
  def change
    create_table :ledger_entry_linkings, id: :uuid do |t|
      t.references :ledger_entry, null: false, foreign_key: true, type: :uuid
      t.references :ledger_entry_link, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
