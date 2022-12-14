class RemoveDateTime < ActiveRecord::Migration[7.0]
  def change
    remove_column :schedule_messages, :time
    remove_column :schedule_messages, :date
  end
end
