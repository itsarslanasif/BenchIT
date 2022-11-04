class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.string :email, null: false, unique: true

      t.timestamps
    end
  end
end
