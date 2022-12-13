class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bench_channel, null: false, foreign_key: true
      t.string :name, default: ''
      t.text :bookmark_URL, null: false

      t.timestamps
    end
  end
end
