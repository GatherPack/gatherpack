class FixActiveStorageVariantRecordsPrimaryKey < ActiveRecord::Migration[8.1]
  def up
    drop_table :active_storage_variant_records

    create_table :active_storage_variant_records, id: :uuid do |t|
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }, type: :uuid
      t.string :variation_digest, null: false
      t.index [ :blob_id, :variation_digest ], name: :index_active_storage_variant_records_uniqueness, unique: true
    end
  end

  def down
    drop_table :active_storage_variant_records

    create_table :active_storage_variant_records do |t|
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }, type: :uuid
      t.string :variation_digest, null: false
      t.index [ :blob_id, :variation_digest ], name: :index_active_storage_variant_records_uniqueness, unique: true
    end
  end
end
