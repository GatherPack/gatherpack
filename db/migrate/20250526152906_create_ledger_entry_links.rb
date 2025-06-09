class CreateLedgerEntryLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :ledger_entry_links, id: :uuid do |t|
      t.timestamps
    end
  end
end
