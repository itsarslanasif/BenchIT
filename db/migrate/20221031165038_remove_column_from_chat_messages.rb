class RemoveColumnFromChatMessages < ActiveRecord::Migration[6.1]
  def change
    remove_column :chat_messages, :conversation_id
  end
end
