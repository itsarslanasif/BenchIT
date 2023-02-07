class AddColumnToConversationMessage < ActiveRecord::Migration[7.0]
  def change
    add_column :conversation_messages, :is_sent_to_chat, :boolean, default: false, null: false
  end
end
