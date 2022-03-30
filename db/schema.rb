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

ActiveRecord::Schema.define(version: 2022_03_30_065344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.string "secret", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "verification_callback_url"
    t.index ["subdomain"], name: "index_accounts_on_subdomain", unique: true
  end

  create_table "applicants", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "external_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id", "external_id"], name: "index_applicants_on_account_id_and_external_id", unique: true
    t.index ["account_id"], name: "index_applicants_on_account_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "email"
    t.string "login", null: false
    t.datetime "active_at"
    t.string "password_digest"
    t.integer "role", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id", null: false
    t.index ["account_id", "login"], name: "index_members_on_account_id_and_login", unique: true
    t.index ["account_id"], name: "index_members_on_account_id"
  end

  create_table "review_result_labels", force: :cascade do |t|
    t.string "label"
    t.text "description"
    t.boolean "final", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "label_ru"
  end

  create_table "verifications", force: :cascade do |t|
    t.bigint "applicant_id", null: false
    t.string "country", limit: 2
    t.string "legacy_verification_id"
    t.string "status", default: "pending", null: false
    t.string "commment"
    t.integer "kind"
    t.json "documents", default: []
    t.json "raw_changebot", default: {}
    t.json "params", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reason"
    t.string "name"
    t.string "last_name"
    t.string "passport_data"
    t.integer "moderator_id"
    t.string "comment"
    t.string "email"
    t.text "user_comment"
    t.text "moderator_comment"
    t.json "review_result_labels", default: []
    t.index ["applicant_id"], name: "index_verifications_on_applicant_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "applicants", "accounts"
  add_foreign_key "members", "accounts"
  add_foreign_key "verifications", "applicants"
end
