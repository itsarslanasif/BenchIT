class RemoveUserGroupTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :user_groups
  end
end
