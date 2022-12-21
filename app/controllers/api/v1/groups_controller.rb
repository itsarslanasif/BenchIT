class Api::V1::GroupsController < Api::ApiController
  before_action :set_group, only: %i[show]

  def index
    render json: Group.all.map{ |group| group if group.members.include?(Current.profile.id) }
  end

  def show
    @messages = @group.bench_conversation.conversation_messages.includes(:profile, :reactions).with_attached_message_attachments
  end

  private

  def set_group
    @group = Group.find(params[:id])
    render json: { message: 'User is not part of this group', status: :not_found } unless Current.profile.group_ids.include?(@group.id)
  end
end
