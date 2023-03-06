class AddUserToChatChannel < ActiveRecord::Migration[7.0]
  def change
    add_reference :chat_channels, :creator, references: :users, type: :uuid, index: true
    add_foreign_key :chat_channels, :users, column: :creator_id
  end
end
