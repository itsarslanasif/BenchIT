class AddColumnToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :clear_status_after, :datetime, default: ""
  end
end
