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

ActiveRecord::Schema.define(version: 2022_05_31_091059) do

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
    t.string "api_jwt_algorithm", default: "ES256", null: false
    t.jsonb "api_jwt_public_key"
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
    t.string "legacy_external_id"
    t.index ["account_id", "external_id"], name: "index_applicants_on_account_id_and_external_id", unique: true
    t.index ["account_id"], name: "index_applicants_on_account_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "iso_code", null: false
    t.string "title_ru", null: false
    t.string "title_en", null: false
    t.jsonb "id_types", default: [], null: false
    t.datetime "archived_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["iso_code"], name: "index_countries_on_iso_code"
  end

  create_table "document_types", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "file_type", null: false
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id", "title"], name: "index_document_types_on_account_id_and_title", unique: true
    t.index ["account_id"], name: "index_document_types_on_account_id"
  end

  create_table "invites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "inviter_id", null: false
    t.citext "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", null: false
    t.index ["account_id"], name: "index_invites_on_account_id"
    t.index ["email"], name: "index_invites_on_email", unique: true
    t.index ["inviter_id"], name: "index_invites_on_inviter_id"
    t.index ["token"], name: "index_invites_on_token", unique: true
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
    t.string "role", default: "operator", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.datetime "archived_at"
    t.index ["account_id"], name: "index_members_on_account_id"
    t.index ["user_id", "account_id"], name: "index_members_on_user_id_and_account_id", unique: true
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "review_result_labels", force: :cascade do |t|
    t.string "label"
    t.text "public_comment"
    t.boolean "final", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "label_ru"
  end

  create_table "users", force: :cascade do |t|
    t.citext "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.integer "failed_logins_count", default: 0
    t.datetime "lock_expires_at"
    t.string "unlock_token"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["unlock_token"], name: "index_users_on_unlock_token"
  end

  create_table "verification_documents", force: :cascade do |t|
    t.bigint "verification_id", null: false
    t.bigint "document_type_id", null: false
    t.string "file", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["document_type_id"], name: "index_verification_documents_on_document_type_id"
    t.index ["verification_id"], name: "index_verification_documents_on_verification_id"
  end

  create_table "verifications", force: :cascade do |t|
    t.bigint "applicant_id", null: false
    t.string "country", limit: 2
    t.string "legacy_external_id"
    t.string "status", default: "pending", null: false
    t.string "commment"
    t.integer "kind"
    t.json "legacy_documents", default: []
    t.json "external_json", default: {}
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
    t.date "birth_date"
    t.string "gender"
    t.text "applicant_comment"
    t.string "remote_ip"
    t.string "user_agent"
    t.string "number"
    t.index ["applicant_id"], name: "index_verifications_on_applicant_id"
    t.index ["legacy_external_id"], name: "index_verifications_on_legacy_external_id", unique: true
    t.index ["number"], name: "index_verifications_on_number", unique: true
  end

  add_foreign_key "applicants", "accounts"
  add_foreign_key "document_types", "accounts"
  add_foreign_key "log_records", "applicants"
  add_foreign_key "log_records", "verifications"
  add_foreign_key "members", "accounts"
  add_foreign_key "members", "users"
  add_foreign_key "verification_documents", "document_types"
  add_foreign_key "verification_documents", "verifications"
  add_foreign_key "verifications", "applicants"
end
