class Api::V1::GroupsController < Api::ApiController
  before_action :set_group, only: [:show]
  def index
    current_user = User.first
    render json: current_user.groups
  end

  def show
    current_user = User.first
    if current_user.group_ids.include?(@group.id)
      @messages = @group.bench_conversation.conversation_messages
      message_data = []
      if @messages.empty?
        response = {
          id: 0,
          group_id: @group.id,
          content: nil,
          is_threaded: false,
          parent_message_id: nil,
          sender_id: nil,
          sender_name: nil,
          bench_conversation_id: @group.bench_conversation.id,
          created_at: nil,
          updated_at: nil
        }
        message_data.push(response)
      else
        @messages.each do |message|
          response = {
            id: message.id,
            group_id: @group.id,
            content:message.content,
            is_threaded:message.is_threaded,
            parent_message_id:message.parent_message_id,
            sender_id:message.sender_id,
            sender_name:message.user.name,
            bench_conversation_id: message.bench_conversation_id,
            created_at: message.created_at,
            updated_at: message.updated_at
          }
          message_data.push(response)
        end
      end
      render json: message_data
    else
      render json: { json: "nooo", status: :unprocessable_entity }
    end
  end

  private
  def set_group
    @group = Group.find_by_id(params[:id])
    return if @group.present?

    render json: { json: @group.errors, status: :unprocessable_entity }
  end
end
