class RenameUserChatChannelsToChannelParticipants < ActiveRecord::Migration[6.1]
  def change
    rename_table :user_chat_channels, :channel_participants
  end
end
