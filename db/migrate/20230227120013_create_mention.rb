class CreateMention < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions, id: :uuid do |t|
      t.references :conversation_message, null: false, foreign_key: true, type: :uuid
      t.references :mentionable, polymorphic: true, type: :uuid, index: true
      t.timestamps
    end
  end
end
