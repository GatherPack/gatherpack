class CreateReplies < ActiveRecord::Migration[8.1]
  def change
    create_table :replies, id: :uuid do |t|
      t.references :question, type: :uuid, null: false, foreign_key: true
      t.references :person, type: :uuid, null: false, foreign_key: true
      t.uuid :parent_id
      t.text :content, null: false

      t.timestamps
    end

    add_index :replies, :parent_id
    add_index :replies, :created_at
  end
end
