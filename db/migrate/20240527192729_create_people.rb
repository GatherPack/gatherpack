class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :display_name
      t.string :gender
      t.string :shirt_size
      t.string :phone_number
      t.string :address
      t.date :birthday
      t.string :dietary_restrictions
      t.references :user, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
