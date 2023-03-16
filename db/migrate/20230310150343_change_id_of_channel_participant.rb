class ChangeIdOfChannelParticipant < ActiveRecord::Migration[7.0]
  def up
    change_column :channel_participants, :id, :string
  end

  def down
    change_column :channel_participants, :id, :bigint, using: 'id::bigint'
  end
end
