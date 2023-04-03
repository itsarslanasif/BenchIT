class AddAndRemoveReferenceOfInvitable < ActiveRecord::Migration[7.0]
  def up
    remove_column :invitables, :user_id
    add_column :invitables, :profile_id, :string, null: false
    add_foreign_key :invitables, :profiles, column: :profile_id, primary_key: :id
    add_index :invitables, :profile_id
    change_column_null :invitables, :token, false
    change_column :invitables, :token_type, :integer, default: 0, null: false, using: 'id::bigint'
    rename_column :invitables, :token_type, :invitation_type
    add_column  :invitables, :email, :string, null: false
    add_index :invitables, [:workspace_id, :email], unique: true
    add_column :invitables, :status, :integer, default: 0, null: false
    add_column :invitables, :has_account, :integer, default: 0, null: false
  end

  def down
    remove_column :invitables, :has_account
    remove_column :invitables, :status
    remove_index :invitables, [:workspace_id, :email]
    remove_column :invitables, :email
    rename_column :invitables, :invitation_type, :token_type
    change_column :invitables, :token_type, :string, null: true
    change_column_null :invitables, :token, true
    remove_column :invitables, :profile_id
    add_column :invitables, :user_id, :string, null: false
    add_foreign_key :invitables, :users, column: :user_id, primary_key: :id
    add_index :invitables, :user_id
  end
end
