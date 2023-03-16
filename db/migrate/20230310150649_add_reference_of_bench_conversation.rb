class AddReferenceOfBenchConversation < ActiveRecord::Migration[7.0]
  def up
    change_column :draft_messages, :bench_conversation_id, :string

    add_foreign_key :draft_messages, :bench_conversations, column: :bench_conversation_id, primary_key: :id
  end

  def down
    remove_foreign_key :draft_messages, :bench_conversations

    change_column :draft_messages, :bench_conversation_id, :integer, using: 'bench_conversation_id::integer'
  end
end
