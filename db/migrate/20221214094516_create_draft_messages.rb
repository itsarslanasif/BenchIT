class CreateDraftMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :draft_messages, id: :string do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true, type: :string
      t.references :bench_conversation, type: :uuid
      t.index [:user_id, :bench_conversation_id], unique: true
      t.timestamps
    end
  end
end
