class AddMetadataToLedgerEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :ledger_entries, :metadata, :jsonb
    add_column :ledger_entries, :finalized, :boolean, default: true
    add_column :ledger_entries, :failed, :boolean, default: false
  end
end
