class CreateChatConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_conversations do |t|
      t.references :conversationable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
