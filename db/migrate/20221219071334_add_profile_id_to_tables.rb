class AddProfileIdToTables < ActiveRecord::Migration[7.0]
  def change
    add_reference :bench_channels, :creator, references: :profiles, type: :string, index: true
    add_foreign_key :bench_channels, :profiles, column: :creator_id
    add_reference :channel_participants, :profile, null: false, foreign_key: true, type: :string, index: true
    add_reference :conversation_messages, :sender, references: :profiles, type: :string, index: true
    add_foreign_key :conversation_messages, :profiles, column: :sender_id
    add_reference :bench_conversations, :sender, references: :profiles, type: :string, index: true
    add_foreign_key :bench_conversations, :profiles, column: :sender_id
  end
end
