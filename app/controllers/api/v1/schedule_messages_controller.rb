class Api::V1::ScheduleMessagesController < Api::ApiController
  before_action :set_schedule_message, only: %i[destroy]

  def index
    @messages = Current.profile.schedule_messages.includes(:bench_conversation, :profile)
  end

  def destroy
    queue = Sidekiq::ScheduledSet.new
    queue.each do |job|
      job.jid if job.jid == @schedule_message.job_id
    end
    @schedule_message.destroy!
  end

  private

  def set_schedule_message
    @schedule_message = ScheduleMessage.find(params[:id])
  end
end
