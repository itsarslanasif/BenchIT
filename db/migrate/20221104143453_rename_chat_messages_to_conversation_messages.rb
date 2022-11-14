class RenameChatMessagesToConversationMessages < ActiveRecord::Migration[7.0]
  def change
    rename_table :chat_messages, :conversation_messages
  end
end
