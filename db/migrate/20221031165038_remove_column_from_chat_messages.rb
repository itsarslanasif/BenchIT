class RemoveColumnFromChatMessages < ActiveRecord::Migration[7.0]
  def change
    remove_column :chat_messages, :chat_conversation_id
  end
end
