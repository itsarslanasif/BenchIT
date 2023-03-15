class AddRoleToChannelParticipant < ActiveRecord::Migration[7.0]
  def change
    add_column :channel_participants, :role, :integer, default: 0
  end
end
