class AddValidationToChatMessagesContent < ActiveRecord::Migration[6.1]
  def change
    change_column :chat_messages, :content, :text, null: false
  end
end
