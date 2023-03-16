class ChangeIdOfPolymorphicTables < ActiveRecord::Migration[7.0]
  def up
    change_column :bookmarks, :id, :string
    change_column :favourites, :id, :string
    change_column :mentions, :id, :string
  end

  def down
    change_column :bookmarks, :id, :bigint, using: 'id::bigint'
    change_column :favourites, :id, :bigint, using: 'id::bigint'
    change_column :mentions, :id, :bigint, using: 'id::bigint'
  end
end
