class AddColumnToConversationMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :conversation_messages, :is_edited, :boolean, default: false
  end
end
