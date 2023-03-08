class CreateSavedItems < ActiveRecord::Migration[7.0]
  def change
    create_table :saved_items, id: :uuid do |t|
      t.string :profile_id
      t.string :conversation_message_id

      t.timestamps
    end
  end
end
