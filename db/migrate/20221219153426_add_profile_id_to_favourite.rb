class AddProfileIdToFavourite < ActiveRecord::Migration[7.0]
  def change
    add_reference :favourites, :profile, null: false, foreign_key: true, index: true
  end
end
