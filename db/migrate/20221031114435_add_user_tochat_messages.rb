class AddUserTochatMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :chat_messages, :sender, references: :users,type: :uuid, index: true
    add_foreign_key :chat_messages, :users, column: :sender_id
  end
end
