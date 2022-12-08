class CreateUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :user_groups, &:timestamps
  end
end
