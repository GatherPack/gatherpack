# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_10_14_232518) do
# Could not dump table "account_relationships" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "accounts" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "action_text_rich_texts" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "active_storage_attachments" because of following StandardError
#   Unknown type 'uuid' for column 'record_id'


  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

# Could not dump table "active_storage_variant_records" because of following StandardError
#   Unknown type 'uuid' for column 'blob_id'


# Could not dump table "announcements" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badge_assignments" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badge_types" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badges" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "checkins" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "event_types" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "events" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "hooks" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "memberships" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "pages" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "people" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "reports" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "team_types" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "teams" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "tokens" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "transactions" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "users" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "variables" because of following StandardError
#   Unknown type 'uuid' for column 'id'


  add_foreign_key "account_relationships", "accounts"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "badge_assignments", "badges"
  add_foreign_key "badge_assignments", "people"
  add_foreign_key "badges", "badge_types"
  add_foreign_key "checkins", "events"
  add_foreign_key "checkins", "people"
  add_foreign_key "events", "event_types"
  add_foreign_key "memberships", "people"
  add_foreign_key "memberships", "teams"
  add_foreign_key "people", "users"
  add_foreign_key "teams", "team_types"
  add_foreign_key "transactions", "accounts"
end
