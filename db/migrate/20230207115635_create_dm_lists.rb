class CreateDmLists < ActiveRecord::Migration[7.0]
  def change
    create_table :dm_lists do |t|
      t.integer :profile_id, null: false
      t.integer :receiver_id, null: false
      t.timestamps
    end
  end
end
