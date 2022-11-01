class AddUserToChatChannel < ActiveRecord::Migration[6.1]
  def change
    # add_reference :chat_channels, :user, null: false, foreign_key: true
    add_reference :chat_channels, :creator, references: :users, index: true
    add_foreign_key :chat_channels, :users, column: :creator_id
  end
end
