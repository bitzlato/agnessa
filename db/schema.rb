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

ActiveRecord::Schema.define(version: 2022_04_07_151056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.string "secret", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "verification_callback_url"
    t.string "email_from"
    t.string "return_url"
    t.text "form_description"
    t.index ["subdomain"], name: "index_accounts_on_subdomain", unique: true
  end

  create_table "applicants", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "external_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "blocked", default: false, null: false
    t.citext "first_name"
    t.citext "last_name"
    t.bigint "last_confirmed_verification_id"
    t.datetime "confirmed_at"
    t.citext "patronymic"
    t.jsonb "emails", default: [], null: false
    t.index ["account_id", "external_id"], name: "index_applicants_on_account_id_and_external_id", unique: true
    t.index ["account_id"], name: "index_applicants_on_account_id"
  end

  create_table "log_records", force: :cascade do |t|
    t.bigint "applicant_id", null: false
    t.bigint "verification_id"
    t.bigint "member_id"
    t.string "action", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["applicant_id"], name: "index_log_records_on_applicant_id"
    t.index ["member_id"], name: "index_log_records_on_member_id"
    t.index ["verification_id"], name: "index_log_records_on_verification_id"
  end

  create_table "members", force: :cascade do |t|
    t.integer "role", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.index ["account_id"], name: "index_members_on_account_id"
    t.index ["user_id", "account_id"], name: "index_members_on_user_id_and_account_id", unique: true
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "review_result_labels", force: :cascade do |t|
    t.string "label"
    t.text "description"
    t.boolean "final", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "label_ru"
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
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
    t.citext "name"
    t.citext "last_name"
    t.string "document_number"
    t.integer "moderator_id"
    t.string "comment"
    t.citext "email"
    t.text "public_comment"
    t.text "private_comment"
    t.json "review_result_labels", default: []
    t.citext "patronymic"
    t.index ["applicant_id"], name: "index_verifications_on_applicant_id"
  end

  add_foreign_key "applicants", "accounts"
  add_foreign_key "log_records", "applicants"
  add_foreign_key "log_records", "verifications"
  add_foreign_key "members", "accounts"
  add_foreign_key "members", "users"
  add_foreign_key "verifications", "applicants"
end
