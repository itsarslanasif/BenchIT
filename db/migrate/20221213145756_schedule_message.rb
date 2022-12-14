class ScheduleMessage < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_messages do |t|
      t.string :content
      t.date :date
      t.time :time
      t.references :bench_conversation, null: false, foreign_key: true
      t.timestamps
    end
  end
end
