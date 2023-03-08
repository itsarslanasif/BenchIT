class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.references :workspace, null: false, foreign_key: true, type: :string
      t.string :username, null: false
      t.text :description, limit: 150

      t.timestamps
    end
  end
end
