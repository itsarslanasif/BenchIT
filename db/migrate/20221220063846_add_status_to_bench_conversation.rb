class AddStatusToBenchConversation < ActiveRecord::Migration[7.0]
  def change
    add_column :bench_conversations, :status, :integer, null: false, default: 0
  end
end
