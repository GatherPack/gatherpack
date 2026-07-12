class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions, id: :uuid do |t|
      t.references :team, type: :uuid, null: false, foreign_key: true
      t.references :person, type: :uuid, null: false, foreign_key: true
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :closed, null: false, default: false

      t.timestamps
    end

    add_index :questions, :created_at
  end
end
