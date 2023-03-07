class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks, id: :uuid do |t|
      t.references :profile, null: false, foreign_key: true, type: :uuid
      t.references :bookmarkable, polymorphic: true, type: :uuid
      t.string :name, default: ''
      t.text :bookmark_URL, null: false

      t.timestamps
    end
  end
end
