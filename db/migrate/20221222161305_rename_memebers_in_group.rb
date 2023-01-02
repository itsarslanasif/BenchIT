class RenameMemebersInGroup < ActiveRecord::Migration[7.0]
  def change
    rename_column :groups, :members, :profile_ids
  end
end
