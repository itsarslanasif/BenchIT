class AddUserAndGroupToUserGroup < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_groups, :user, null: false, foreign_key: true
    add_reference :user_groups, :group, null: false, foreign_key: true
  end
end
