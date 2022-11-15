class AddValidationToChatChannelsName < ActiveRecord::Migration[7.0]
  def change
    change_column :chat_channels, :name, :string, null: false
    add_index :chat_channels, :name, unique: true
  end
end
