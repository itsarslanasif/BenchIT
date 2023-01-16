class AddUniquenessOnPin < ActiveRecord::Migration[7.0]
  def change
    add_index :pins, [:conversation_message_id, :bench_conversation_id], unique: true
  end
end
