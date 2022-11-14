class RenameChatChannelsToBenchChannels < ActiveRecord::Migration[7.0]
  def change
    rename_table :chat_channels, :bench_channels
  end
end
