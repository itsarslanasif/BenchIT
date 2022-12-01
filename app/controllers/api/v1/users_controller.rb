class Api::V1::UsersController < Api::ApiController
  before_action :set_user, only: %i[show]

  def index
    @users = User.all
    render json: @users
  end

  def show
    current_user = User.first
    @conversation = BenchConversation.user_to_user_conversation(current_user.id, @receiver.id)

    if @conversation.blank?
      @conversation = BenchConversation.create(conversationable_type: 'User', conversationable_id: @receiver.id, sender_id: current_user.id)
    end

    @messages = @conversation.conversation_messages
    if @messages.empty?
      render status: 200, json: { message: 'chat does not exist',status_code:"1" }
    else
      render "api/v1/bench_channels/show"
    end
  end

  private

  def set_user
    @receiver = User.find(params[:id])
  end
end
