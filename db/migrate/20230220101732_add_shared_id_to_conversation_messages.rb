class AddSharedIdToConversationMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :conversation_messages, :shared_message_id, :integer, default: nil
  end
end
