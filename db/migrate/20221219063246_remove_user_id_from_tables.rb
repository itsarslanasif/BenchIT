class RemoveUserIdFromTables < ActiveRecord::Migration[7.0]
  def change
    remove_column :bench_channels, :creator_id
    remove_column :channel_participants, :user_id
    remove_column :user_groups, :user_id
    remove_column :conversation_messages, :sender_id
    remove_column :bench_conversations, :sender_id
  end
end
