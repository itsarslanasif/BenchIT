class AddColToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :verification_token, :string
    add_column :users, :verified, :boolean, default: true
  end
end
