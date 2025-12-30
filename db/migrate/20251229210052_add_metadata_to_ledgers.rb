class AddMetadataToLedgers < ActiveRecord::Migration[8.1]
  def change
    add_column :ledgers, :metadata, :jsonb, default: {}, null: false
  end
end
