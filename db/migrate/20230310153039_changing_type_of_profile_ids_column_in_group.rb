class ChangingTypeOfProfileIdsColumnInGroup < ActiveRecord::Migration[7.0]
  def up
    change_column :groups, :profile_ids, :string, array: true
  end

  def down; end
end
