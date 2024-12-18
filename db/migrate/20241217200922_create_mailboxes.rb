class CreateMailboxes < ActiveRecord::Migration[8.0]
  def change
    create_table :mailboxes, id: :uuid do |t|
      t.string :address

      t.timestamps
    end
  end
end
