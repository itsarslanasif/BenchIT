class AddDateTimeColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :schedule_messages, :timedate, :datetime
  end
end
