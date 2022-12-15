class Api::V1::GroupsController < Api::ApiController
  before_action :set_group, only: %i[show]

  def index
    render json: current_user.groups
  end

  def show
    @messages = @group.bench_conversation.conversation_messages.includes(:user, :reactions).with_attached_message_attachments
  end

  private

  def set_group
    @group = Group.find(params[:id])
    render json: { message: 'User is not part of this group', status: :not_found } unless current_user.group_ids.include?(@group.id)
  end
end
