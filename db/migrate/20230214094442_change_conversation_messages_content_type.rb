class ChangeConversationMessagesContentType < ActiveRecord::Migration[7.0]
  def up
    change_column :conversation_messages, :content, 'json USING content::json'
  end

  def down
    change_column :conversation_messages, :content, :text
  end
end
