class ChangeStatusesColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :statuses, :clear_after, :string
  end
end
