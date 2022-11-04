class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.string :username, null: false
      t.text :description, limit: 150
      t.bigint :workspace_id, null: false
      t.references :identity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
