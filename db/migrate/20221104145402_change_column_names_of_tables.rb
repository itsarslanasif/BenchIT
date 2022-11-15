class ChangeColumnNamesOfTables < ActiveRecord::Migration[7.0]
  def change
    rename_column :channel_participants, :chat_channel_id, :bench_channel_id
    rename_column :conversation_messages, :chat_conversation_id, :bench_conversation_id
  end
end
