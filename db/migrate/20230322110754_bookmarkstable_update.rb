class BookmarkstableUpdate < ActiveRecord::Migration[7.0]
  def up
    remove_column :bookmarks, :bookmarkable_id
    remove_column :bookmarks, :bookmarkable_type
    remove_column :bookmarks, :profile_id
    add_reference :bookmarks, :bench_conversation, null: false, foreign_key: true, type: :string
  end

  def down
    add_column :bookmarks, :bookmarkable_id, :string
    add_column :bookmarks, :bookmarkable_type, :string
    add_column :bookmarks, :profile_id, :string
    remove_reference :bookmarks, :bench_conversation, null: false, foreign_key: true, type: :string
  end

end
