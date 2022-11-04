class RenameChatConversationsToBenchConversations < ActiveRecord::Migration[6.1]
  def change
    rename_table :chat_conversations, :bench_conversations
  end
end
