class RenameChatMessagesToConversationMessages < ActiveRecord::Migration[6.1]
  def change
    rename_table :chat_messages, :conversation_messages
  end
end
