class RemoveUseridFromReactions < ActiveRecord::Migration[7.0]
  def up
    remove_column :reactions, :user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
