class CreateTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :tokens, id: KeyTypePicker.key_type do |t|
      t.string :value
      t.references :tokenable, polymorphic: true, type: :uuid
      t.timestamps
    end
  end
end
