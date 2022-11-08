class RenameSlackUrlToBenchItUrl < ActiveRecord::Migration[6.1]
  def change
    rename_column :workspaces, :slack_URL, :benchIT_URL
  end
end
