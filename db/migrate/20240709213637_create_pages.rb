class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages, id: :uuid do |t|
      t.string :title
      t.text :content
      t.string :viewer, default: 'user'
      t.string :editor, default: 'admin'
      t.boolean :dynamic, default: false
      t.references :team, null: true, foreign_key: false, type: :uuid

      t.timestamps
    end
  end
end
