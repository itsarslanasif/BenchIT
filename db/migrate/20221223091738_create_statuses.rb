class CreateStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :statuses do |t|
      t.string :text
      t.string :emoji
      t.string :clear_after
      t.uuid :profile_id
      t.integer :type
      t.uuid :workspace_id

      t.timestamps
    end
  end
end
