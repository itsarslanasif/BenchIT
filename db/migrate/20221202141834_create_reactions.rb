class CreateReactions < ActiveRecord::Migration[7.0]
  def change
    create_table :reactions, id: :uuid do |t|
      t.string :user_id
      t.string :conversation_message_id
      t.string :emoji

      t.timestamps
    end
  end
end
