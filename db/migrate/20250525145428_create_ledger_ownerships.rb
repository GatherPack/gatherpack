class CreateLedgerOwnerships < ActiveRecord::Migration[8.0]
  def change
    create_table :ledger_ownerships, id: :uuid do |t|
      t.references :ledger, null: false, foreign_key: true, type: :uuid
      t.references :owner, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
