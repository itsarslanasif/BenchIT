class AddOnlineStatusColumnToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :online_status, :boolean, default: false, null: false
  end
end
