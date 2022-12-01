class Api::V1::GroupsController < Api::ApiController
  before_action :set_group, only: %i[show]

  def index
    current_user = User.first
    render json: current_user.groups
  end

  def show
    current_user = User.first
    if current_user.group_ids.include?(@group.id)
      @messages = @group.bench_conversation.conversation_messages
      if @messages.empty?
        render status: 200, json: {message: 'chat does not exist',status_code:"1"}
      else
        render "api/v1/bench_channels/show"
      end
    else
      render json: { message: 'nooo', status: :unprocessable_entity }
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end
end
