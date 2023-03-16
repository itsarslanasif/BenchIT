class UpdateProfileId < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :bench_channels, :profiles
    remove_foreign_key :channel_participants, :profiles
    remove_foreign_key :bench_conversations, :profiles
    remove_foreign_key :conversation_messages, :profiles
    remove_foreign_key :schedule_messages, :profiles
    remove_foreign_key :draft_messages, :profiles
    remove_foreign_key :reactions, :profiles
    remove_foreign_key :pins, :profiles
    remove_foreign_key :bookmarks, :profiles
    remove_foreign_key :favourites, :profiles
    remove_foreign_key :preferences, :profiles
    remove_foreign_key :downloads, :profiles

    change_column :profiles, :id, :string

    change_column :bench_channels, :creator_id, :string
    change_column :channel_participants, :profile_id, :string
    change_column :bench_conversations, :sender_id, :string
    change_column :conversation_messages, :sender_id, :string
    change_column :schedule_messages, :profile_id, :string
    change_column :draft_messages, :profile_id, :string
    change_column :reactions, :profile_id, :string
    change_column :pins, :profile_id, :string
    change_column :bookmarks, :profile_id, :string
    change_column :favourites, :profile_id, :string
    change_column :preferences, :profile_id, :string
    change_column :downloads, :profile_id, :string

    add_foreign_key :bench_channels, :profiles, column: :creator_id, primary_key: :id
    add_foreign_key :channel_participants, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :bench_conversations, :profiles, column: :sender_id, primary_key: :id
    add_foreign_key :conversation_messages, :profiles, column: :sender_id, primary_key: :id
    add_foreign_key :schedule_messages, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :draft_messages, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :reactions, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :pins, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :bookmarks, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :favourites, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :preferences, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :downloads, :profiles, column: :profile_id, primary_key: :id
  end

  def down
    remove_foreign_key :bench_channels, :profiles
    remove_foreign_key :channel_participants, :profiles
    remove_foreign_key :bench_conversations, :profiles
    remove_foreign_key :conversation_messages, :profiles
    remove_foreign_key :schedule_messages, :profiles
    remove_foreign_key :draft_messages, :profiles
    remove_foreign_key :reactions, :profiles
    remove_foreign_key :pins, :profiles
    remove_foreign_key :bookmarks, :profiles
    remove_foreign_key :favourites, :profiles
    remove_foreign_key :preferences, :profiles
    remove_foreign_key :downloads, :profiles

    change_column :profiles, :id, :bigint, using: 'id::bigint'

    change_column :bench_channels, :creator_id, :bigint, using: 'creator_id::bigint'
    change_column :channel_participants, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :bench_conversations, :sender_id, :bigint, using: 'sender_id::bigint'
    change_column :conversation_messages, :sender_id, :bigint, using: 'sender_id::bigint'
    change_column :schedule_messages, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :draft_messages, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :reactions, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :pins, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :bookmarks, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :favourites, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :preferences, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :downloads, :profile_id, :bigint, using: 'profile_id::bigint'

    add_foreign_key :bench_channels, :profiles, column: :creator_id, primary_key: :id
    add_foreign_key :channel_participants, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :bench_conversations, :profiles, column: :sender_id, primary_key: :id
    add_foreign_key :conversation_messages, :profiles, column: :sender_id, primary_key: :id
    add_foreign_key :schedule_messages, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :draft_messages, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :reactions, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :pins, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :bookmarks, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :favourites, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :preferences, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :downloads, :profiles, column: :profile_id, primary_key: :id
  end
end
