class RenameChatConversationsToBenchConversations < ActiveRecord::Migration[7.0]
  def change
    rename_table :chat_conversations, :bench_conversations
  end
end
