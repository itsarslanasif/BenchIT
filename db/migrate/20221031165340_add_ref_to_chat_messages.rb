class AddRefToChatMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :chat_messages, :chat_conversation, foreign_key: true, type: :uuid
  end
end
