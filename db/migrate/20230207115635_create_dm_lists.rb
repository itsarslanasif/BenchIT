class CreateDmLists < ActiveRecord::Migration[7.0]
  def change
    create_table :dm_users do |t|
      t.integer :profile_id, null: false
      t.integer :receiver_id, null: false
      t.timestamps
    end
    add_index :dm_users, [:receiver_id, :profile_id], unique: true
  end
end
