class AddMutedToChannelParticipants < ActiveRecord::Migration[7.0]
  def change
    remove_column :profiles, :muted_channels, :integer
    add_column :channel_participants, :muted, :boolean, default: false, null: false
  end
end
