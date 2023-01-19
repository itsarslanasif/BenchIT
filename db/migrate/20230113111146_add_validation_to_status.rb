class AddValidationToStatus < ActiveRecord::Migration[7.0]
  def change
    change_column_null :statuses, :text, false
    change_column_null :statuses, :emoji, false
    change_column_null :statuses, :clear_after, false
    change_column_null :statuses, :type, false
  end
end
