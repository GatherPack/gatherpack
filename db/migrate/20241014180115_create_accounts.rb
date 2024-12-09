class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :name
      t.references :team, null: true, foreign_key: false, type: :uuid

      t.timestamps
    end
  end
end
