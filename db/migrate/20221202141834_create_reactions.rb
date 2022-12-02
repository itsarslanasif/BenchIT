class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions do |t|
      t.integer :user_id
      t.integer :conversation_message_id
      t.string :emoji

      t.timestamps
    end
  end
end
