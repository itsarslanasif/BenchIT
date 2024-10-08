class CreateWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workspaces do |t|
      t.string :company_name, null: false
      t.integer :workspace_type, null: false, default: 0
      t.string :benchIT_URL, null: false
      t.integer :capacity, null: false
      t.integer :organization_type, null: false, default: 0
      t.integer :admin_role, null: false, default: 0
      t.timestamps
    end
  end
end
