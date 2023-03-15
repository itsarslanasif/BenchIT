class UpdateUserColumnInInvitable < ActiveRecord::Migration[7.0]
  def up
    change_column :invitables, :user_id, :string

    add_foreign_key :invitables, :users, column: :user_id, primary_key: :id

    add_index :invitables, :user_id
  end

  def down
    remove_index :invitables, :user_id

    remove_foreign_key :invitables, :users

    change_column :invitables, :user_id, :bigint, using: 'user_id::bigint'
  end
end
