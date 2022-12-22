class AddProfileIdToTables < ActiveRecord::Migration[7.0]
  def change
    add_reference :bench_channels, :creator, references: :profiles, index: true
    add_foreign_key :bench_channels, :profiles, column: :creator_id
    add_reference :channel_participants, :profile, null: false, foreign_key: true, index: true
    add_reference :conversation_messages, :sender, references: :profiles, index: true
    add_foreign_key :conversation_messages, :profiles, column: :sender_id
    add_reference :bench_conversations, :sender, references: :profiles, index: true
    add_foreign_key :bench_conversations, :profiles, column: :sender_id
  end
end
