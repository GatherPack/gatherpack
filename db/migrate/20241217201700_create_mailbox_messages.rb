class CreateMailboxMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :mailbox_messages, id: :uuid do |t|
      t.string :from
      t.string :subject
      t.string :body
      t.belongs_to :mailbox, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
