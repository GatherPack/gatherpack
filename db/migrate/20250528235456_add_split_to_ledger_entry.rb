class AddSplitToLedgerEntry < ActiveRecord::Migration[8.0]
  def change
    add_reference :ledger_entries, :parent, null: true, type: :uuid
  end
end
