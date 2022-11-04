class RenameChatChannelsToBenchChannels < ActiveRecord::Migration[6.1]
  def change
    rename_table :chat_channels, :bench_channels
  end
end
