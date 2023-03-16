class UpdateUserAndProfileColumns < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :profiles, :users

    change_column :users, :id, :string

    change_column :profiles, :user_id, :string

    add_foreign_key :profiles, :users, column: :user_id, primary_key: :id
  end

  def down
    remove_foreign_key :profiles, :users

    change_column :users, :id, :bigint, using: 'id::bigint'

    change_column :profiles, :user_id, :bigint, using: 'user_id::bigint'

    add_foreign_key :profiles, :users, column: :user_id, primary_key: :id
  end
end
