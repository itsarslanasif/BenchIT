class RemoveUserGroupTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :user_groups
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
