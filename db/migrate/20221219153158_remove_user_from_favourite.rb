class RemoveUserFromFavourite < ActiveRecord::Migration[7.0]
  def up
    remove_column :favourites, :user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
