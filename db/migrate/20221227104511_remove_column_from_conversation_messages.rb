class RemoveColumnFromConversationMessages < ActiveRecord::Migration[7.0]
  def change
    remove_column :conversation_messages, :is_edited, :boolean
  end
end
