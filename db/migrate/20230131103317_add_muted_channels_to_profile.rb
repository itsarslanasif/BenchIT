class AddMutedChannelsToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :muted_channels, :integer, array: true, default: []
  end
end
