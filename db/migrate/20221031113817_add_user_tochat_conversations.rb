class AddUserTochatConversations < ActiveRecord::Migration[6.1]
  def change
    add_reference :chat_conversations, :sender, references: :users, index: true
    add_foreign_key :chat_conversations, :users, column: :sender_id
  end
end
