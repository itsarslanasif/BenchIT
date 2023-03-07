class CreateChatMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :chat_messages, id: :uuid do |t|
      t.text :content
      t.boolean :is_threaded
      t.references :chat_conversation, null: false, foreign_key: true, type: :uuid
      t.references :parent_message, type: :uuid
      t.timestamps
    end
  end
end
