class AddUniquenessOnTables < ActiveRecord::Migration[7.0]
  def change
    add_index :reactions, [:emoji, :conversation_message_id, :profile_id], unique: true, name: 'reaction_index'
    add_index :bench_conversations, [:conversationable_id, :conversationable_type, :sender_id], unique: true, name: 'bench_conversation_index'
    add_index :favourites, [:favourable_id, :favourable_type, :profile_id], unique: true, name: 'favourite_index'
  end
end
