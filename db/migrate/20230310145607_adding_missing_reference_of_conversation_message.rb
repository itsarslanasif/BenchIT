class AddingMissingReferenceOfConversationMessage < ActiveRecord::Migration[7.0]
  def up
    change_column :conversation_messages, :parent_message_id, :string
    change_column :reactions, :conversation_message_id, :string
    change_column :saved_items, :conversation_message_id, :string

    add_foreign_key :conversation_messages, :conversation_messages, column: :parent_message_id, primary_key: :id
    add_foreign_key :reactions, :conversation_messages, column: :conversation_message_id, primary_key: :id
    add_foreign_key :saved_items, :conversation_messages, column: :conversation_message_id, primary_key: :id

    add_index :reactions, :conversation_message_id
    add_index :saved_items, :conversation_message_id
  end

  def down
    remove_index :reactions, :conversation_message_id
    remove_index :saved_items, :conversation_message_id

    remove_foreign_key :conversation_messages, column: :parent_message_id
    remove_foreign_key :reactions, column: :conversation_message_id
    remove_foreign_key :saved_items, column: :conversation_message_id

    change_column :conversation_messages, :parent_message_id, :integer, using: 'parent_message_id::integer'
    change_column :reactions, :conversation_message_id, :integer, using: 'conversation_message_id::integer'
    change_column :saved_items, :conversation_message_id, :integer, using: 'conversation_message_id::integer'
  end
end
