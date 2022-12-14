class Api::V1::ScheduleMessagesController < Api::ApiController
before_action :fetch_conversation, only: %i[create]

  def index
    render json: ScheduleMessage.all
  end

  def create

    @message = ScheduleMessage.new(schedule_messages_params)
    @message.bench_conversation_id = @bench_conversation.id
    response = @message.save ? { message: 'Message sheduled.' } : { message: @message.errors, status: :unprocessable_entity }
    render json: response
    # SendScheduleMessagesJob.perform_later(content, bench_conversation_id , sender_id, timedate)
  end

  def destroy
    render json: @message.destroy ? { message: ' Sheduled message deleted successfully.' } : { message: @message.errors, status: :unprocessable_entity }
  end

  def edit
    render json: @message.edit ? { message: ' Sheduled message deleted successfully.' } : { message: @message.errors, status: :unprocessable_entity }
  end

private

def schedule_messages_params
  params.permit( :content, :sender_id, :timedate )
end

  def fetch_conversation
    conversation_id = params[:conversation_id]

    @bench_conversation = case params[:conversation_type]
                          when 'channels'
                            BenchChannel.find_by(id: conversation_id)&.bench_conversation
                          when 'groups'
                            Group.find_by(id: conversation_id)&.bench_conversation
                          when 'users'
                            BenchConversation.user_to_user_conversation(params[:sender_id], conversation_id)
                          end
    render json: { message: 'wrong type', status: :unprocessable_entity } if @bench_conversation.blank?
  end

end
