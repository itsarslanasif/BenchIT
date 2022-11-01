class AddRefToChatMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :chat_messages, :chat_conversation, foreign_key:true
  end
end
