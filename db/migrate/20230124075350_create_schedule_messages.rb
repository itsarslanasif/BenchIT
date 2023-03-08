class CreateScheduleMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_messages, id: :string do |t|
      t.text :content, null: false
      t.string :scheduled_at, null: false
      t.string :job_id, null: false, default: ''
      t.references :profile, null: false, foreign_key: true, type: :string
      t.references :bench_conversation, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
