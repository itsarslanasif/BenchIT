class ChangeDraftMessage < ActiveRecord::Migration[7.0]
  def up
    remove_index :draft_messages, name: 'index_draft_messages_on_profile_id_and_bench_conversation_id'
    add_reference :draft_messages, :conversation_message, null: true, foreign_key: true, type: :string, index: true
    add_index :draft_messages, [:profile_id, :bench_conversation_id, :conversation_message_id], unique: true, name: 'draft_message'
  end

  def down
    add_index :draft_messages, [:profile_id, :bench_conversation_id], unique: true
    remove_column :draft_messages, :conversation_message_id
  end
end
