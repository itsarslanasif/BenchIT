class Api::V1::ConversationMessagesController < Api::ApiController
  include MemberShip
  include Pagination

  before_action :fetch_conversation, :verify_membership, only: %i[create]
  before_action :set_message, :authenticate_message, only: %i[destroy update]
  before_action :set_saved_item, only: %i[unsave_message]
  before_action :set_bench_channel, only: %i[bench_channel_messages]
  before_action :set_group, only: %i[group_messages]
  before_action :set_receiver, only: %i[profile_messages]
  after_action :marked_chat_read, only: %i[bench_channel_messages profile_messages group_messages]

  def send_message
    @pagy, @messages = pagination_for_send_messages(params[:page])
  end

  def create
    if params[:scheduled_at].blank?
      @message = @bench_conversation.conversation_messages.new(conversation_messages_params)
      @message.save!

      render json: { success: true, message: t('.create.success') }, status: :ok
    else
      @schedule_message = @bench_conversation.schedule_messages.new(schedule_messages_params)
      @schedule_message.save!
    end
  end

  def update
    @message.update!(conversation_messages_params)
    render json: { success: true, message: t('.update.success') }, status: :ok
  end

  def destroy
    if delete_parent_message?
      @message.parent_message.destroy!
    elsif soft_delete_message?
      soft_delete_message
    else
      @message.destroy!
    end

    render json: { success: true, message: t('.destroy.success') }, status: :ok
  end

  def index_saved_messages
    @pagy, @saved_items = pagination_for_save_messages(params[:page])
  end

  def save_message
    @saved_item = current_profile.saved_items.new(conversation_message_id: params[:id])
    @saved_item.save!
  end

  def unsave_message
    @saved_item.destroy!
    render json: { success: true, message: t('.unsave_message.success') }, status: :ok
  end

  def recent_files
    @messages = current_profile.conversation_messages.includes(:profile, :reactions).with_attached_message_attachments
  end

  def bench_channel_messages
    @conversation = @bench_channel.bench_conversation
    paginate_messages
  end

  def group_messages
    @conversation = @group.bench_conversation
    paginate_messages
  end

  def profile_messages
    @conversation = BenchConversation.profile_to_profile_conversation(current_profile.id, @receiver.id)
    create_conversation if @conversation.blank?
    @current_profile.direct_message_users.create(receiver_id: @receiver.id)
    paginate_messages
  end

  def create_conversation
    @conversation = BenchConversation.create(conversationable_type: 'Profile', conversationable_id: @receiver.id, sender_id: current_profile.id)
  end

  def unread_messages
    str = REDIS.get("unreadMessages#{current_workspace.id}#{current_profile.id}")
    @previous_unread_messages_details = str.nil? ? {} : JSON.parse(str)
  end

  private

  def paginate_messages
    @pagy, @messages = pagination_for_chat_messages(@conversation.id, params[:page])

    return render json: { success: false, error: t('.paginate_messages.failure') }, status: :not_found if @pagy.nil?
  end

  def set_saved_item
    @saved_item = current_profile.saved_items.find_by(conversation_message_id: params[:id])

    return render json: { failure: false, message: t('.set_saved_item.failure') }, status: :not_found if @saved_item.nil?
  end

  def set_message
    @message = ConversationMessage.find(params[:id])
  end

  def conversation_messages_params
    params.permit(:content, :is_threaded, :parent_message_id, :is_sent_to_chat, message_attachments: []).tap do |param|
      param[:sender_id] = current_profile.id
    end
  end

  def schedule_messages_params
    params.permit(:content, :scheduled_at).tap do |param|
      param[:profile_id] = current_profile.id
    end
  end

  def fetch_conversation
    conversation_id = params[:conversation_id]

    @bench_conversation = case params[:conversation_type]
                          when 'channels'
                            BenchChannel.find_by(id: conversation_id)&.bench_conversation
                          when 'groups'
                            Group.find_by(id: conversation_id)&.bench_conversation
                          when 'profiles'
                            BenchConversation.profile_to_profile_conversation(current_profile.id, conversation_id)
                          end
    render json: { success: false, error: t('.fetch_conversation.failure') }, status: :bad_request if @bench_conversation.blank?
  end

  def set_bench_channel
    @bench_channel = BenchChannel.find(params[:id])
    return if !@bench_channel.is_private || current_profile.bench_channel_ids.include?(@bench_channel.id)

    render json: { success: false, error: t('.set_bench_channel.failure') }, status: :not_found
  end

  def set_group
    @group = Group.find(params[:id])
    return if @group.profile_ids.include?(current_profile.id)

    render json: { success: false, error: t('.set_group.failure') }, status: :not_found
  end

  def set_receiver
    @receiver = Profile.find(params[:id])
    return if @receiver.workspace_id.eql?(current_workspace.id)

    render json: { success: false, error: t('.set_receiver.failure') }, status: :unprocessable_entity
  end

  def authenticate_message
    if @message.sender_id.eql?(current_profile.id)
      check_membership(@message.bench_conversation)
    else
      render json: { success: false, error: t('.authenticate_message.failure') }, status: :unauthorized
    end
  end

  def verify_membership
    check_membership(@bench_conversation)
  end

  def marked_chat_read
    UnreadMessagesMarkedAsReadService.new(@conversation).call
  end

  def delete_parent_message?
    msg = t('.delete_text')
    @message.parent_message_id.present? && @message.parent_message.content.eql?(msg) && @message.parent_message.replies.count.eql?(1)
  end

  def soft_delete_message?
    @message.parent_message_id.blank? && @message.replies.count.positive?
  end

  def soft_delete_message
    ActiveRecord::Base.transaction do
      @message.pin&.destroy!
      @message.reactions&.delete_all
      @message.saved_items&.delete_all
      @message.message_attachments&.delete_all
      @message.update!(content: t('.delete_text'))
    end
  end
end
