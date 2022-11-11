class AddUserAndChannelToUserChannel < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_chat_channels, :user, null: false, foreign_key: true
    add_reference :user_chat_channels, :chat_channel, null: false, foreign_key: true
  end
end
