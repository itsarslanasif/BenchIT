class CreateSavedItems < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_items do |t|
      t.integer :profile_id
      t.integer :conversation_message_id

      t.timestamps
    end
  end
end
