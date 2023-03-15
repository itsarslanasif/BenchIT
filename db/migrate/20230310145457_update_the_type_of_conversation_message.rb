class UpdateTheTypeOfConversationMessage < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :draft_messages, :conversation_messages
    remove_foreign_key :pins, :conversation_messages
    remove_foreign_key :mentions, :conversation_messages

    change_column :conversation_messages, :id, :string

    change_column :draft_messages, :conversation_message_id, :string
    change_column :pins, :conversation_message_id, :string
    change_column :mentions, :conversation_message_id, :string

    add_foreign_key :draft_messages, :conversation_messages, column: :conversation_message_id, primary_key: :id
    add_foreign_key :pins, :conversation_messages, column: :conversation_message_id, primary_key: :id
    add_foreign_key :mentions, :conversation_messages, column: :conversation_message_id, primary_key: :id
  end

  def down
    remove_foreign_key :draft_messages, :conversation_messages
    remove_foreign_key :pins, :conversation_messages
    remove_foreign_key :mentions, :conversation_messages

    change_column :conversation_messages, :id, :bigint, using: 'id::bigint'

    change_column :draft_messages, :conversation_message_id, :bigint, using: 'conversation_message_id::bigint'
    change_column :pins, :conversation_message_id, :bigint, using: 'conversation_message_id::bigint'
    change_column :mentions, :conversation_message_id, :bigint, using: 'conversation_message_id::bigint'

    add_foreign_key :draft_messages, :conversation_messages, column: :conversation_message_id, primary_key: :id
    add_foreign_key :pins, :conversation_messages, column: :conversation_message_id, primary_key: :id
    add_foreign_key :mentions, :conversation_messages, column: :conversation_message_id, primary_key: :id
  end
end
