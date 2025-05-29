class CreateLedgers < ActiveRecord::Migration[8.0]
  def change
    create_table :ledgers, id: :uuid do |t|
      t.string :name
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.integer :balance_cents, default: 0

      t.timestamps
    end
  end
end
