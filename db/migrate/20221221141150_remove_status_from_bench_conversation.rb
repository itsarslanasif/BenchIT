class RemoveStatusFromBenchConversation < ActiveRecord::Migration[7.0]
  def up
    remove_column :bench_conversations, :status
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
