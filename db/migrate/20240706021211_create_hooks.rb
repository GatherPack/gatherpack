class CreateHooks < ActiveRecord::Migration[8.0]
  def change
    create_table :hooks, id: :uuid do |t|
      t.string :name
      t.string :event
      t.text :code

      t.timestamps
    end
  end
end
