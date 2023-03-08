class CreateFavourites < ActiveRecord::Migration[7.0]
  def change
    create_table :favourites, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.references :favourable, polymorphic: true, type: :string, index: true
      t.timestamps
    end
  end
end
