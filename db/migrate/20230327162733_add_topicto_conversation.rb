class AddTopictoConversation < ActiveRecord::Migration[7.0]
  def change
    add_column :bench_conversations, :topic, :string
  end
end
