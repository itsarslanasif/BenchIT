class AddSenderToSchedule < ActiveRecord::Migration[7.0]
  def change
    add_reference :schedule_messages, :sender, references: :users, index: true, null: false
  end
end
