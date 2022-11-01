class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.text :content
      t.boolean :is_threaded
      t.references :conversation, null: false, foreign_key: true
      t.references :parent_message
      t.timestamps
    end
  end
end
