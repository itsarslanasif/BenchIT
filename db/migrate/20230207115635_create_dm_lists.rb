class CreateDmLists < ActiveRecord::Migration[7.0]
  def change
    create_table :direct_message_users do |t|
      t.uuid :profile_id, null: false
      t.uuid :receiver_id, null: false
      t.timestamps
    end
    add_index :direct_message_users, [:receiver_id, :profile_id], unique: true
  end
end
