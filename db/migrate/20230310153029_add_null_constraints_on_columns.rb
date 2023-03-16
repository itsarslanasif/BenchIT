class AddNullConstraintsOnColumns < ActiveRecord::Migration[7.0]
  def up
    change_column_null :bench_channels, :creator_id, false
    change_column_null :bench_conversations, :conversationable_id, false
    change_column_null :bench_conversations, :conversationable_type, false
    change_column_null :bookmarks, :bookmarkable_id, false
    change_column_null :bookmarks, :bookmarkable_type, false
    change_column_null :mentions, :mentionable_id, false
    change_column_null :mentions, :mentionable_type, false
    change_column_null :favourites, :favourable_id, false
    change_column_null :favourites, :favourable_type, false
    change_column_null :conversation_messages, :bench_conversation_id, false
    change_column_null :conversation_messages, :sender_id, false
    change_column_null :draft_messages, :bench_conversation_id, false
    change_column_null :invitables, :user_id, false
    change_column_null :invitables, :workspace_id, false
    change_column_null :saved_items, :conversation_message_id, false
    change_column_null :saved_items, :profile_id, false
    change_column_null :channel_participants, :role, false
  end

  def down
    change_column_null :bench_channels, :creator_id, true
    change_column_null :bench_conversations, :conversationable_id, true
    change_column_null :bench_conversations, :conversationable_type, true
    change_column_null :bookmarks, :bookmarkable_id, true
    change_column_null :bookmarks, :bookmarkable_type, true
    change_column_null :mentions, :mentionable_id, true
    change_column_null :mentions, :mentionable_type, true
    change_column_null :favourites, :favourable_id, true
    change_column_null :favourites, :favourable_type, true
    change_column_null :conversation_messages, :bench_conversation_id, true
    change_column_null :conversation_messages, :sender_id, true
    change_column_null :draft_messages, :bench_conversation_id, true
    change_column_null :invitables, :user_id, true
    change_column_null :invitables, :workspace_id, true
    change_column_null :saved_items, :conversation_message_id, true
    change_column_null :saved_items, :profile_id, true
    change_column_null :channel_participants, :role, true
  end
end
