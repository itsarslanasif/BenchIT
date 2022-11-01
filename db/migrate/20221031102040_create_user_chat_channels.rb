class CreateUserChatChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :user_chat_channels do |t|
      t.boolean :permission, default:true
      t.datetime :left_on

      t.timestamps
    end
  end
end
