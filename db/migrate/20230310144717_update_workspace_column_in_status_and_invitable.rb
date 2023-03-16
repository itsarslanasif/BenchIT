class UpdateWorkspaceColumnInStatusAndInvitable < ActiveRecord::Migration[7.0]
  def up
    change_column :statuses, :workspace_id, :string
    change_column :invitables, :workspace_id, :string

    add_foreign_key :statuses, :workspaces, column: :workspace_id, primary_key: :id
    add_foreign_key :invitables, :workspaces, column: :workspace_id, primary_key: :id

    add_index :statuses, :workspace_id
    add_index :invitables, :workspace_id
  end

  def down
    remove_index :statuses, :workspace_id
    remove_index :invitables, :workspace_id

    remove_foreign_key :statuses, :workspaces
    remove_foreign_key :invitables, :workspaces

    change_column :statuses, :workspace_id, :bigint, using: 'workspace_id::bigint'
    change_column :invitables, :workspace_id, :bigint, using: 'workspace_id::bigint'
  end
end
