class CreateReplyVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :reply_votes, id: :uuid do |t|
      t.references :reply, type: :uuid, null: false, foreign_key: true
      t.references :person, type: :uuid, null: false, foreign_key: true
      t.references :question, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reply_votes, [ :person_id, :question_id ], unique: true
  end
end
