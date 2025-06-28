class CreateGateways < ActiveRecord::Migration[8.0]
  def change
    create_table :gateways, id: :uuid do |t|
      t.string :name
      t.string :type
      t.jsonb :configuration

      t.timestamps
    end
  end
end
