class AddValidationToChatMessagesContent < ActiveRecord::Migration[7.0]
  def change
    change_column :chat_messages, :content, :text, null: false
  end
end
