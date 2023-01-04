class CreatePin < ActiveRecord::Migration[7.0]
  def change
    create_table :pins do |t|
      t.references :conversation_message, null: false, foreign_key: true, index: true
      t.references :profile, null: false, foreign_key: true, index: true
      t.references :bench_conversation, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
