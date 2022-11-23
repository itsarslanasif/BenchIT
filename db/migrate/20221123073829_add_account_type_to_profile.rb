class AddAccountTypeToProfile < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :account_type, :integer
  end
end
