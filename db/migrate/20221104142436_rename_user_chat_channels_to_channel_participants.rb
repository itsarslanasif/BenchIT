class RenameUserChatChannelsToChannelParticipants < ActiveRecord::Migration[7.0]
  def change
    rename_table :user_chat_channels, :channel_participants
  end
end
