class CreateMention < ActiveRecord::Migration[7.0]
  def change
    create_table :mentions do |t|
      t.references :conversation_message, null: false, foreign_key: true
      t.references :mentionable, polymorphic: true, type: :uuid, index: true
      t.timestamps
    end
  end
end
