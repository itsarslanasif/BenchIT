class AddIndexToDraftMessages < ActiveRecord::Migration[7.0]
  def change
    add_index :draft_messages, [:profile_id, :bench_conversation_id], unique: true
  end
end
