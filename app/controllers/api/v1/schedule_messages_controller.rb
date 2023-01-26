class Api::V1::ScheduleMessagesController < Api::ApiController
  include MemberShip

  before_action :set_schedule_message, :authenticat_message, only: %i[destroy update]

  def index
    @messages = Current.profile.schedule_messages.includes(:bench_conversation, :profile)
  end

  def destroy
    queue = Sidekiq::ScheduledSet.new
    queue.each do |job|
      next unless job.jid.eql?(@schedule_message.job_id)

      job.delete
      @schedule_message.destroy!
      break
    end
  end

  private

  def set_schedule_message
    @schedule_message = ScheduleMessage.find(params[:id])
  end

  def authenticat_message
    if @schedule_message.profile_id.eql?(Current.profile.id)
      check_membership(@schedule_message.bench_conversation)
    else
      render json: { error: 'Sorry, this message is not yours.' }, status: :unauthorized
    end
  end
end
