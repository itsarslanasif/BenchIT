class CreateChatChannels < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_channels do |t|
      t.string :name
      t.text :description
      t.boolean :is_private, default: false

      t.timestamps
    end
  end
end
