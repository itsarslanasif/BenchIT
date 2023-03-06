class AddUserTochatConversations < ActiveRecord::Migration[7.0]
  def change
    add_reference :chat_conversations, :sender, references: :users,type: :uuid, index: true
    add_foreign_key :chat_conversations, :users, column: :sender_id
  end
end
