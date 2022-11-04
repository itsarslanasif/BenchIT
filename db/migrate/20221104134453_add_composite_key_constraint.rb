class AddCompositeKeyConstraint < ActiveRecord::Migration[6.1]
  def change
    add_index :profiles, [:workspace_id, :identity_id], unique: true
  end
end
