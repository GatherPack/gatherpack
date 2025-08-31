class AddFailedToLedgerEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :ledger_entries, :failed, :boolean, default: false
  end
end
