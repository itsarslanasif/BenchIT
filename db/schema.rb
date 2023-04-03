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

ActiveRecord::Schema[7.0].define(version: 2023_03_29_160906) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.string "record_id", null: false
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

  create_table "bench_channels", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "is_private", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "workspace_id", null: false
    t.string "creator_id", null: false
    t.index ["creator_id"], name: "index_bench_channels_on_creator_id"
    t.index ["name", "workspace_id"], name: "index_bench_channels_on_name_and_workspace_id", unique: true
    t.index ["workspace_id"], name: "index_bench_channels_on_workspace_id"
  end

  create_table "bench_conversations", id: :serial, force: :cascade do |t|
    t.string "conversationable_type", null: false
    t.string "conversationable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sender_id"
    t.index ["conversationable_id", "conversationable_type", "sender_id"], name: "bench_conversation_index", unique: true
    t.index ["conversationable_type", "conversationable_id"], name: "index_chat_conversations_on_conversationable"
    t.index ["sender_id"], name: "index_bench_conversations_on_sender_id"
  end

  create_table "bookmark_folders", id: :string, force: :cascade do |t|
    t.string "name", null: false
    t.string "bench_conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bench_conversation_id"], name: "index_bookmark_folders_on_bench_conversation_id"
  end

  create_table "bookmarks", id: :serial, force: :cascade do |t|
    t.string "name", default: ""
    t.text "bookmark_URL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bench_conversation_id", null: false
    t.string "bookmark_folder_id"
    t.index ["bench_conversation_id"], name: "index_bookmarks_on_bench_conversation_id"
    t.index ["bookmark_folder_id"], name: "index_bookmarks_on_bookmark_folder_id"
  end

  create_table "channel_participants", id: :serial, force: :cascade do |t|
    t.boolean "permission", default: true
    t.datetime "left_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bench_channel_id", null: false
    t.string "profile_id", null: false
    t.boolean "muted", default: false, null: false
    t.integer "role", default: 0, null: false
    t.index ["bench_channel_id", "profile_id"], name: "index_channel_participants_on_bench_channel_id_and_profile_id", unique: true
    t.index ["bench_channel_id"], name: "index_channel_participants_on_bench_channel_id"
    t.index ["profile_id"], name: "index_channel_participants_on_profile_id"
  end

  create_table "conversation_messages", id: :serial, force: :cascade do |t|
    t.json "content"
    t.boolean "is_threaded"
    t.string "parent_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bench_conversation_id", null: false
    t.string "sender_id", null: false
    t.boolean "is_info", default: false, null: false
    t.boolean "is_sent_to_chat", default: false, null: false
    t.string "shared_message_id"
    t.index ["bench_conversation_id"], name: "index_conversation_messages_on_bench_conversation_id"
    t.index ["parent_message_id"], name: "index_conversation_messages_on_parent_message_id"
    t.index ["sender_id"], name: "index_conversation_messages_on_sender_id"
    t.index ["shared_message_id"], name: "index_conversation_messages_on_shared_message_id"
  end

  create_table "direct_message_users", id: :serial, force: :cascade do |t|
    t.string "profile_id", null: false
    t.string "receiver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_direct_message_users_on_profile_id"
    t.index ["receiver_id", "profile_id"], name: "index_direct_message_users_on_receiver_id_and_profile_id", unique: true
  end

  create_table "downloads", id: :serial, force: :cascade do |t|
    t.string "profile_id", null: false
    t.string "file_name", null: false
    t.string "file_link", null: false
    t.string "file_download_link", null: false
    t.string "file_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_downloads_on_profile_id"
  end

  create_table "draft_messages", id: :serial, force: :cascade do |t|
    t.json "content", null: false
    t.string "bench_conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_id", null: false
    t.string "conversation_message_id"
    t.index ["bench_conversation_id"], name: "index_draft_messages_on_bench_conversation_id"
    t.index ["conversation_message_id"], name: "index_draft_messages_on_conversation_message_id"
    t.index ["profile_id", "bench_conversation_id", "conversation_message_id"], name: "draft_message", unique: true
    t.index ["profile_id"], name: "index_draft_messages_on_profile_id"
  end

  create_table "favourites", id: :serial, force: :cascade do |t|
    t.string "favourable_type", null: false
    t.string "favourable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_id", null: false
    t.index ["favourable_id", "favourable_type", "profile_id"], name: "favourite_index", unique: true
    t.index ["favourable_type", "favourable_id"], name: "index_favourites_on_favourable"
    t.index ["profile_id"], name: "index_favourites_on_profile_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_ids", default: [], array: true
  end

  create_table "invitables", id: :serial, force: :cascade do |t|
    t.string "token", null: false
    t.string "workspace_id", null: false
    t.integer "invitation_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_id", null: false
    t.string "email", null: false
    t.integer "status", default: 0, null: false
    t.integer "has_account", default: 0, null: false
    t.index ["profile_id"], name: "index_invitables_on_profile_id"
    t.index ["token"], name: "index_invitables_on_token"
    t.index ["workspace_id", "email"], name: "index_invitables_on_workspace_id_and_email", unique: true
    t.index ["workspace_id"], name: "index_invitables_on_workspace_id"
  end

  create_table "mentions", id: :serial, force: :cascade do |t|
    t.string "conversation_message_id", null: false
    t.string "mentionable_type", null: false
    t.string "mentionable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_message_id"], name: "index_mentions_on_conversation_message_id"
    t.index ["mentionable_type", "mentionable_id"], name: "index_mentions_on_mentionable"
  end

  create_table "pins", id: :serial, force: :cascade do |t|
    t.string "conversation_message_id", null: false
    t.string "profile_id", null: false
    t.string "bench_conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bench_conversation_id"], name: "index_pins_on_bench_conversation_id"
    t.index ["conversation_message_id", "bench_conversation_id"], name: "index_pins_on_conversation_message_id_and_bench_conversation_id", unique: true
    t.index ["conversation_message_id"], name: "index_pins_on_conversation_message_id"
    t.index ["profile_id"], name: "index_pins_on_profile_id"
  end

  create_table "preferences", id: :serial, force: :cascade do |t|
    t.string "profile_id", null: false
    t.json "notifications", default: "{\"notify_me_about\": 1, [], \"my_keywords\": [], \"allow_notifications\": \"\", \"default_time_for_remider_notifications\": \"\", \"sound_and_appearance: [1],}", null: false
    t.json "sidebar", default: "{\"alway_show_in_sidebar\":[1,2,5,6], \"show\": 1, \"sort\":{1,[1,4,5,6]} }", null: false
    t.json "themes", default: "{\"sync_with_os_settings\": true, \"colors\":4,}", null: false
    t.json "messages_and_media", default: "{\"theme\": 1, \"names\": 1, \"additional_options\": [1, 3], \"emoji\": { \"default_skin_tone\": 1, \"additional_options\": [2, 4],\"one_click_emoji\": 2 },\"inline_media_and_links\": [1, 2]}", null: false
    t.json "language_and_region", default: "{\"language\": \"English(US)\", \"timezone\":\"Islamabad,Karachi\", \"spell_check\":true}", null: false
    t.json "accessibility", default: "{\"zoom\": 4, \"links\": true, \"animation\": true, \"message_format\": 1, \"direct_message_announcements\":true, \"huddles_announcements\":[1, 2], \"keyboard\": 1}", null: false
    t.json "mark_as_read", default: "{\"when_i_view_a_channel\": 1, \"when_i_mark_everything_as_read\": true}", null: false
    t.json "audio_and_video", default: "{\"microphone\": {1, [1, 2]}, \"speaker\": 1, \"when_joining_a_slackcall\": [1], \"when_joining_a_huddle\": [1,4,5], \"when_slack_is_in_the_background\": true, \"when_your_screen_saver_starts_or_computer_locks\": [1, 2]}", null: false
    t.json "connected_accounts", default: "{\"links_and_content_from_other_apps\": true}", null: false
    t.json "privacy_and_visibility", default: "{\"slack_connect_discoverability\": 1, \"contact_sharing\": 1 }", null: false
    t.json "advanced", default: "{\"input_options\": [], \"when_writing_a_message\": 1, \"search_options\": \"\", \"download_action\": {true,\"\"}, \"confirmations_and_warnings\": [1, 2, 3, 4], \"other_options\": [1]}", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_preferences_on_profile_id"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.string "user_id", null: false
    t.string "workspace_id", null: false
    t.string "username", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 3
    t.string "display_name", limit: 80, default: "", null: false
    t.string "title", default: "", null: false
    t.string "pronounce_name", default: "", null: false
    t.string "text_status", limit: 100, default: "", null: false
    t.string "emoji_status", default: "", null: false
    t.string "phone", default: "", null: false
    t.string "skype", default: ""
    t.string "time_zone", default: "UTC", null: false
    t.datetime "clear_status_after"
    t.boolean "is_active", default: false, null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
    t.index ["workspace_id", "user_id"], name: "index_profiles_on_workspace_id_and_user_id", unique: true
    t.index ["workspace_id"], name: "index_profiles_on_workspace_id"
  end

  create_table "reactions", id: :serial, force: :cascade do |t|
    t.string "conversation_message_id"
    t.string "emoji"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_id", null: false
    t.index ["conversation_message_id"], name: "index_reactions_on_conversation_message_id"
    t.index ["emoji", "conversation_message_id", "profile_id"], name: "reaction_index", unique: true
    t.index ["profile_id"], name: "index_reactions_on_profile_id"
  end

  create_table "saved_items", id: :serial, force: :cascade do |t|
    t.string "profile_id", null: false
    t.string "conversation_message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_message_id", "profile_id"], name: "index_saved_items_on_conversation_message_id_and_profile_id", unique: true
    t.index ["conversation_message_id"], name: "index_saved_items_on_conversation_message_id"
    t.index ["profile_id"], name: "index_saved_items_on_profile_id"
  end

  create_table "schedule_messages", id: :serial, force: :cascade do |t|
    t.json "content", null: false
    t.string "scheduled_at", null: false
    t.string "job_id", default: "", null: false
    t.string "profile_id", null: false
    t.string "bench_conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bench_conversation_id"], name: "index_schedule_messages_on_bench_conversation_id"
    t.index ["profile_id"], name: "index_schedule_messages_on_profile_id"
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.string "text", null: false
    t.string "emoji", null: false
    t.string "clear_after", null: false
    t.string "profile_id"
    t.string "workspace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_statuses_on_profile_id"
    t.index ["workspace_id"], name: "index_statuses_on_workspace_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.string "verification_token"
    t.boolean "verified", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workspaces", id: :serial, force: :cascade do |t|
    t.string "company_name", null: false
    t.integer "workspace_type", default: 0, null: false
    t.string "bench_it_url", null: false
    t.integer "capacity", null: false
    t.integer "organization_type", default: 0, null: false
    t.integer "admin_role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bench_it_url"], name: "index_workspaces_on_bench_it_url", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bench_channels", "profiles", column: "creator_id"
  add_foreign_key "bench_channels", "workspaces"
  add_foreign_key "bench_conversations", "profiles", column: "sender_id"
  add_foreign_key "bookmark_folders", "bench_conversations"
  add_foreign_key "bookmarks", "bench_conversations"
  add_foreign_key "bookmarks", "bookmark_folders"
  add_foreign_key "channel_participants", "bench_channels"
  add_foreign_key "channel_participants", "profiles"
  add_foreign_key "conversation_messages", "bench_conversations"
  add_foreign_key "conversation_messages", "conversation_messages", column: "parent_message_id"
  add_foreign_key "conversation_messages", "conversation_messages", column: "shared_message_id"
  add_foreign_key "conversation_messages", "profiles", column: "sender_id"
  add_foreign_key "direct_message_users", "profiles"
  add_foreign_key "downloads", "profiles"
  add_foreign_key "draft_messages", "bench_conversations"
  add_foreign_key "draft_messages", "conversation_messages"
  add_foreign_key "draft_messages", "profiles"
  add_foreign_key "favourites", "profiles"
  add_foreign_key "invitables", "profiles"
  add_foreign_key "invitables", "workspaces"
  add_foreign_key "mentions", "conversation_messages"
  add_foreign_key "pins", "bench_conversations"
  add_foreign_key "pins", "conversation_messages"
  add_foreign_key "pins", "profiles"
  add_foreign_key "preferences", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "profiles", "workspaces"
  add_foreign_key "reactions", "conversation_messages"
  add_foreign_key "reactions", "profiles"
  add_foreign_key "saved_items", "conversation_messages"
  add_foreign_key "saved_items", "profiles"
  add_foreign_key "schedule_messages", "bench_conversations"
  add_foreign_key "schedule_messages", "profiles"
  add_foreign_key "statuses", "profiles"
  add_foreign_key "statuses", "workspaces"
end
