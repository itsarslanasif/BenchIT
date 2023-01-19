class AddIsInfoToConversationMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :conversation_messages, :is_info, :boolean, default: false, null: false
  end
end
