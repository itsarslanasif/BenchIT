class AddMutedToChannelParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :channel_participants, :muted, :boolean, default: false, null: false
  end
end
