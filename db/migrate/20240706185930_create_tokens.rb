class CreateTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :tokens, id: :uuid do |t|
      t.string :value
      t.references :tokenable, polymorphic: true, type: :uuid
      t.timestamps
    end
  end
end
