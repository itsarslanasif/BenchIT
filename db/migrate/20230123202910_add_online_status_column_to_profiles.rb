class AddOnlineStatusColumnToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :is_active, :boolean, default: false, null: false
  end
end
