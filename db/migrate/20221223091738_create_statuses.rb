class CreateStatuses < ActiveRecord::Migration[7.0]
  def change
    create_table :statuses, id: :uuid do |t|
      t.string :text
      t.string :emoji
      t.string :clear_after
      t.string :profile_id
      t.integer :type
      t.string :workspace_id

      t.timestamps
    end
  end
end
