class CreateDraftMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :draft_messages do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.references :bench_conversation
      t.timestamps
    end
  end
end
