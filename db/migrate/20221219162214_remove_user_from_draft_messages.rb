class RemoveUserFromDraftMessages < ActiveRecord::Migration[7.0]
  def up
    remove_column :draft_messages, :user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
