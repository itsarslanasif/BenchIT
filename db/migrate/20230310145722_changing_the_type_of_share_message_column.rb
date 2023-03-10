class ChangingTheTypeOfShareMessageColumn < ActiveRecord::Migration[7.0]
  def up
    change_column :conversation_messages, :shared_message_id, :string

    add_foreign_key :conversation_messages, :conversation_messages, column: :shared_message_id, primary_key: :id

    add_index :conversation_messages, :shared_message_id
  end

  def down
    remove_index :conversation_messages, :shared_message_id

    remove_foreign_key :conversation_messages, column: :shared_message_id

    change_column :conversation_messages, :shared_message_id, :integer, using: 'shared_message_id::integer'
  e
end
