class CreateCheckinFieldResponses < ActiveRecord::Migration[8.0]
  def change
    create_table :checkin_field_responses, id: :uuid do |t|
      t.references :checkin, null: false, foreign_key: true, type: :uuid
      t.references :checkin_field, null: false, foreign_key: true, type: :uuid
      t.string :response

      t.timestamps
    end
  end
end
