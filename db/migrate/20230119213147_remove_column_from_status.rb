class RemoveColumnFromStatus < ActiveRecord::Migration[7.0]
  def change
    remove_column :statuses, :type, :integer
  end
end
