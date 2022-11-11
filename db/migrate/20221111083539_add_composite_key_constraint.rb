class AddCompositeKeyConstraint < ActiveRecord::Migration[7.0]
  def change
    add_index :profiles, [:workspace_id, :user_id], unique: true
  end
end
