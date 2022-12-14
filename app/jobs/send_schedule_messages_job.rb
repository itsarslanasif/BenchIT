class SendScheduleMessagesJob < ApplicationJob
  queue_as :default

  def perform_at(schedule_message)
    binding.irb
      if schedule_message.timedate == DateTime.current {
        ConversationMessages.create!(schedule_message)
      }
    elsif schedule_message.timedate > DateTime.current{
      schedule_message.destroy
    }
    end
  end
end
