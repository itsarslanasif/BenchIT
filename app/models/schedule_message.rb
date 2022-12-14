class ScheduleMessage < ApplicationRecord
  belongs_to :bench_conversation
  belongs_to :user, foreign_key: :sender_id, inverse_of: :schedule_messages

end
