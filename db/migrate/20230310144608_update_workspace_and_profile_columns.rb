class UpdateWorkspaceAndProfileColumns < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :profiles, :workspaces
    remove_foreign_key :bench_channels, :workspaces

    change_column :workspaces, :id, :string

    change_column :profiles, :workspace_id, :string
    change_column :bench_channels, :workspace_id, :string

    add_foreign_key :profiles, :workspaces, column: :workspace_id, primary_key: :id
    add_foreign_key :bench_channels, :workspaces, column: :workspace_id, primary_key: :id
  end

  def down
    remove_foreign_key :profiles, :workspaces
    remove_foreign_key :bench_channels, :workspaces

    change_column :workspaces, :id, :bigint, using: 'id::bigint'

    change_column :profiles, :workspace_id, :bigint, using: 'workspace_id::bigint'
    change_column :bench_channels, :workspace_id, :bigint, using: 'workspace_id::bigint'

    add_foreign_key :profiles, :workspaces, column: :workspace_id, primary_key: :id
    add_foreign_key :bench_channels, :workspaces, column: :workspace_id, primary_key: :id
  end
end
