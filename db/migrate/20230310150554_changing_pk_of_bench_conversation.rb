class ChangingPkOfBenchConversation < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :conversation_messages, :bench_conversations
    remove_foreign_key :schedule_messages, :bench_conversations
    remove_foreign_key :pins, :bench_conversations

    change_column :bench_conversations, :id, :string

    change_column :conversation_messages, :bench_conversation_id, :string
    change_column :schedule_messages, :bench_conversation_id, :string
    change_column :pins, :bench_conversation_id, :string

    add_foreign_key :conversation_messages, :bench_conversations, column: :bench_conversation_id, primary_key: :id
    add_foreign_key :schedule_messages, :bench_conversations, column: :bench_conversation_id, primary_key: :id
    add_foreign_key :pins, :bench_conversations, column: :bench_conversation_id, primary_key: :id
  end

  def down
    remove_foreign_key :conversation_messages, :bench_conversations
    remove_foreign_key :schedule_messages, :bench_conversations
    remove_foreign_key :pins, :bench_conversations

    change_column :bench_conversations, :id, :bigint, using: 'id::bigint'

    change_column :conversation_messages, :bench_conversation_id, :bigint, using: 'bench_conversation_id::bigint'
    change_column :schedule_messages, :bench_conversation_id, :bigint, using: 'bench_conversation_id::bigint'
    change_column :pins, :bench_conversation_id, :bigint, using: 'bench_conversation_id::bigint'

    add_foreign_key :conversation_messages, :bench_conversations, column: :bench_conversation_id, primary_key: :id
    add_foreign_key :schedule_messages, :bench_conversations, column: :bench_conversation_id, primary_key: :id
    add_foreign_key :pins, :bench_conversations, column: :bench_conversation_id, primary_key: :id
  end
end
