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

ActiveRecord::Schema[8.0].define(version: 2024_06_18_223426) do
# Could not dump table "action_text_rich_texts" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "active_storage_attachments" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "active_storage_blobs" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "active_storage_variant_records" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badge_assignments" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badge_types" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "badges" because of following StandardError
# Could not dump table "event_types" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "events" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "memberships" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "people" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "reports" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "team_types" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "teams" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "users" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "variables" because of following StandardError
#   Unknown type 'uuid' for column 'id'


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
