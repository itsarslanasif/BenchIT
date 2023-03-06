class CreateFavourites < ActiveRecord::Migration[7.0]
  def change
    create_table :favourites do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :favourable, polymorphic: true, type: :uuid, index: true
      t.timestamps
    end
  end
end
