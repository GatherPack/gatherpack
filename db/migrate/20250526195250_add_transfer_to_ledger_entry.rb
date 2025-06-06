class AddTransferToLedgerEntry < ActiveRecord::Migration[8.0]
  def change
    add_column :ledger_entries, :transfer_mirror, :boolean, default: false
  end
end
