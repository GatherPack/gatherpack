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

ActiveRecord::Schema[8.0].define(version: 2024_07_09_213637) do
  create_table "action_text_rich_texts", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.string "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.string "record_id", null: false
    t.string "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

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

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.string "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

# Could not dump table "announcements" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badge_assignments" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badge_types" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badges" because of following StandardError
#   Unknown type 'uuid' for column 'id'


  create_table "event_types", id: :string, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", id: :string, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "location"
    t.string "event_type_id", null: false
    t.string "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["team_id"], name: "index_events_on_team_id"
  end

  create_table "hooks", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "event"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memberships", id: :string, force: :cascade do |t|
    t.string "person_id", null: false
    t.string "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "manager", default: false
    t.index ["person_id"], name: "index_memberships_on_person_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
  end

# Could not dump table "pages" because of following StandardError
#   Unknown type 'uuid' for column 'team_id'


  create_table "people", id: :string, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "display_name"
    t.string "gender"
    t.string "shirt_size"
    t.string "phone_number"
    t.string "address"
    t.date "birthday"
    t.string "dietary_restrictions"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "reports", id: :string, force: :cascade do |t|
    t.string "name"
    t.text "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_types", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.string "team_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "join_permission", default: 0
    t.index ["team_type_id"], name: "index_teams_on_team_type_id"
  end

# Could not dump table "tokens" because of following StandardError
#   Unknown type 'uuid' for column 'tokenable_id'


  create_table "users", id: :string, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variables", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "klass"
    t.text "raw_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "badge_assignments", "badges"
  add_foreign_key "badge_assignments", "people"
  add_foreign_key "badges", "badge_types"
  add_foreign_key "events", "event_types"
  add_foreign_key "memberships", "people"
  add_foreign_key "memberships", "teams"
  add_foreign_key "people", "users"
  add_foreign_key "teams", "team_types"
end
