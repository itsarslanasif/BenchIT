class CreateChatConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_conversations, id: :uuid do |t|
      t.references :conversationable, polymorphic: true, type: :uuid, index: true
      t.timestamps
    end
  end
end
