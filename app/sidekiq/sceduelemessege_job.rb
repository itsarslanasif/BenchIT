class SceduelemessegeJob
  include Sidekiq::Job

  def perform(schedule_message)
      if schedule_message.timedate == DateTime.current {
        ConversationMessages.create!(schedule_message)
      }
    elsif schedule_message.timedate > DateTime.current{
      schedule_message.destroy
    }
    end
  end
end
