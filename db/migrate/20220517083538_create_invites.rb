class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table "invites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
      t.integer "account_id", null: false
      t.integer "inviter_id", null: false
      t.citext "email", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "token", null: false
      t.index ["account_id"], name: "index_invites_on_account_id"
      t.index ["inviter_id"], name: "index_invites_on_inviter_id"
      t.index ["token"], name: "index_invites_on_token", unique: true
    end

    add_index :invites, :email, unique: true
  end
end
