class CreateUserChatChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :user_chat_channels, id: :uuid do |t|
      t.boolean :permission, default: true
      t.timestamps
    end
  end
end
