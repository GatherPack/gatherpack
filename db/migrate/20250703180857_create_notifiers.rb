class CreateNotifiers < ActiveRecord::Migration[8.0]
  def change
    create_table :notifiers, id: :uuid do |t|
      t.references :person, null: false, foreign_key: true, type: :uuid
      t.jsonb :scope
      t.jsonb :schedule
      t.jsonb :target

      t.timestamps
    end
  end
end
