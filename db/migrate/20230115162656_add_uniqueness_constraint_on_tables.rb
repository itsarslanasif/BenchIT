class AddUniquenessConstraintOnTables < ActiveRecord::Migration[7.0]
  def change
    add_index :channel_participants, [:bench_channel_id, :profile_id], unique: true
    add_index :saved_items, [:conversation_message_id, :profile_id], unique: true
    add_index :workspaces, [:bench_it_url], unique: true
  end
end
