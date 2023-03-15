class ChangingColumnInPolymorphicTables < ActiveRecord::Migration[7.0]
  def up
    change_column :bench_conversations, :conversationable_id, :string
    change_column :bookmarks, :bookmarkable_id, :string
    change_column :favourites, :favourable_id, :string
    change_column :mentions, :mentionable_id, :string
  end

  def down
    change_column :bench_conversations, :conversationable_id, :bigint, using: 'conversationable_id::bigint'
    change_column :bookmarks, :bookmarkable_id, :bigint, using: 'bookmarkable_id::bigint'
    change_column :favourites, :favourable_id, :bigint, using: 'favourable_id::bigint'
    change_column :mentions, :mentionable_id, :bigint, using: 'mentionable_id::bigint'
  end
end
