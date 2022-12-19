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

ActiveRecord::Schema[7.0].define(version: 2022_12_19_071550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bench_channels", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "is_private", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "workspace_id", null: false
    t.bigint "creator_id"
    t.index ["creator_id"], name: "index_bench_channels_on_creator_id"
    t.index ["name"], name: "index_bench_channels_on_name", unique: true
    t.index ["workspace_id"], name: "index_bench_channels_on_workspace_id"
  end

  create_table "bench_conversations", force: :cascade do |t|
    t.string "conversationable_type"
    t.bigint "conversationable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sender_id"
    t.index ["conversationable_type", "conversationable_id"], name: "index_chat_conversations_on_conversationable"
    t.index ["sender_id"], name: "index_bench_conversations_on_sender_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bench_channel_id", null: false
    t.string "name", default: ""
    t.text "bookmark_URL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bench_channel_id"], name: "index_bookmarks_on_bench_channel_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "channel_participants", force: :cascade do |t|
    t.boolean "permission", default: true
    t.datetime "left_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bench_channel_id", null: false
    t.bigint "profile_id", null: false
    t.index ["bench_channel_id"], name: "index_channel_participants_on_bench_channel_id"
    t.index ["profile_id"], name: "index_channel_participants_on_profile_id"
  end

  create_table "conversation_messages", force: :cascade do |t|
    t.text "content", null: false
    t.boolean "is_threaded"
    t.bigint "parent_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bench_conversation_id"
    t.bigint "sender_id"
    t.index ["bench_conversation_id"], name: "index_conversation_messages_on_bench_conversation_id"
    t.index ["parent_message_id"], name: "index_conversation_messages_on_parent_message_id"
    t.index ["sender_id"], name: "index_conversation_messages_on_sender_id"
  end

  create_table "draft_messages", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.bigint "bench_conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bench_conversation_id"], name: "index_draft_messages_on_bench_conversation_id"
    t.index ["user_id", "bench_conversation_id"], name: "index_draft_messages_on_user_id_and_bench_conversation_id", unique: true
    t.index ["user_id"], name: "index_draft_messages_on_user_id"
  end

  create_table "favourites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "favourable_type"
    t.bigint "favourable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["favourable_type", "favourable_id"], name: "index_favourites_on_favourable"
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "members", default: [], array: true
  end

  create_table "invitables", force: :cascade do |t|
    t.string "token"
    t.integer "user_id"
    t.integer "workspace_id"
    t.string "token_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_invitables_on_token"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "workspace_id", null: false
    t.string "username", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 3
    t.index ["user_id"], name: "index_profiles_on_user_id"
    t.index ["workspace_id", "user_id"], name: "index_profiles_on_workspace_id_and_user_id", unique: true
    t.index ["workspace_id"], name: "index_profiles_on_workspace_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "conversation_message_id"
    t.string "emoji"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "saved_items", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "conversation_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "name"
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "company_name", null: false
    t.integer "workspace_type", default: 0, null: false
    t.string "bench_it_url", null: false
    t.integer "capacity", null: false
    t.integer "organization_type", default: 0, null: false
    t.integer "admin_role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bench_channels", "profiles", column: "creator_id"
  add_foreign_key "bench_channels", "workspaces"
  add_foreign_key "bench_conversations", "profiles", column: "sender_id"
  add_foreign_key "bookmarks", "bench_channels"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "channel_participants", "bench_channels"
  add_foreign_key "channel_participants", "profiles"
  add_foreign_key "conversation_messages", "bench_conversations"
  add_foreign_key "conversation_messages", "profiles", column: "sender_id"
  add_foreign_key "draft_messages", "users"
  add_foreign_key "favourites", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "profiles", "workspaces"
  add_foreign_key "reactions", "users"
end
