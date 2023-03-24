class CreateBookmarkFolders < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmark_folders, id: :string do |t|
      t.string :name, null: false
      t.references :bench_conversation, null: false, foreign_key: true, type: :string
      t.timestamps
    end
    add_reference :bookmarks, :bookmark_folder, foreign_key: true, optional: true, type: :string
  end
end
