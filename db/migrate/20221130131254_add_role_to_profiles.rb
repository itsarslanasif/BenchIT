class AddRoleToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :role, :integer, default: 2
  end
end
