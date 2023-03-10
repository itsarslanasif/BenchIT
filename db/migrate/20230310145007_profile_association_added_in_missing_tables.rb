class ProfileAssociationAddedInMissingTables < ActiveRecord::Migration[7.0]
  def up
    change_column :saved_items, :profile_id, :string
    change_column :statuses, :profile_id, :string
    change_column :direct_message_users, :profile_id, :string

    add_foreign_key :saved_items, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :statuses, :profiles, column: :profile_id, primary_key: :id
    add_foreign_key :direct_message_users, :profiles, column: :profile_id, primary_key: :id

    add_index :saved_items, :profile_id
    add_index :statuses, :profile_id
    add_index :direct_message_users, :profile_id
  end

  def down
    remove_index :saved_items, :profile_id
    remove_index :statuses, :profile_id
    remove_index :direct_message_users, :profile_id

    remove_foreign_key :saved_items, :profiles
    remove_foreign_key :statuses, :profiles
    remove_foreign_key :direct_message_users, :profiles

    change_column :saved_items, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :statuses, :profile_id, :bigint, using: 'profile_id::bigint'
    change_column :direct_message_users, :profile_id, :bigint, using: 'profile_id::bigint'
  end
end
