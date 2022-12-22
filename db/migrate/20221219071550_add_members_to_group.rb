class AddMembersToGroup < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :members, :integer, array: true, default: []
  end
end
