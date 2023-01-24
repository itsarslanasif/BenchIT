class CreateScheduleMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_messages do |t|
      t.text :content, null: false
      t.datetime :scheduled_at, null: false
      t.string :job_id, null: false, default: ''
      t.references :profile, null: false, foreign_key: true
      t.references :bench_conversation, null: false, foreign_key: true
      t.timestamps
    end
  end
end
