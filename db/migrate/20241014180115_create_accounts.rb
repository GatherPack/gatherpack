class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts, id: KeyTypePicker.key_type do |t|
      t.string :name
      t.references :team, null: true, type: :uuid

      t.timestamps
    end
  end
end
