class CreateMailboxAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :mailbox_assignments, id: :uuid do |t|
      t.belongs_to :mailbox, null: false, foreign_key: true, type: :uuid
      t.belongs_to :target, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
