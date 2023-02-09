class Api::V1::ConversationMessagesController < Api::ApiController
  include MemberShip
  include Pagination

  before_action :fetch_conversation, :verify_membership, only: %i[create]
  before_action :set_message, :authenticat_message, only: %i[destroy update]
  before_action :set_saved_item, only: %i[unsave_message]
  before_action :set_bench_channel, only: %i[bench_channel_messages]
  before_action :set_group, only: %i[group_messages]
  before_action :set_receiver, only: %i[profile_messages]
  after_action :marked_chat_read, only: %i[bench_channel_messages profile_messages group_messages]

  def send_message
    @messages = Current.profile.conversation_messages.includes(:profile, :reactions).order(created_at: :desc)
  end

  def create
    if params[:scheduled_at].blank?
      @message = @bench_conversation.conversation_messages.new(conversation_messages_params)
      @message.save!

      render json: { success: 'Message sent', message: @message }, status: :ok
    else
      @schedule_message = @bench_conversation.schedule_messages.new(schedule_messages_params)
      @schedule_message.save!
    end
  end

  def update
    if @message.update(conversation_messages_params)
      render json: { success: 'Message updated', message: @message }, status: :ok
    else
      render json: { error: 'Message not updated', errors: @message.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if delete_parent_message?
      @message.parent_message.destroy!
    elsif soft_delete_message?
      soft_delete_message
    else
      @message.destroy!
    end

    render json: { message: 'Message deleted successfully.' }
  end

  def index_saved_messages
    @saved_items = Current.profile.saved_items.order(created_at: :desc)
  end

  def save_message
    @saved_item = Current.profile.saved_items.new(conversation_message_id: params[:id])

    return if @saved_item.save

    render json: { error: 'Added to saved items', errors: @saved_item.errors }, status: :unprocessable_entity
  end

  def unsave_message
    if @saved_item.destroy
      render json: { message: 'Removed from saved items' }, status: :ok
    else
      render json: { error: 'Unable to remove from saved items', errors: @saved_item.errors }, status: :unprocessable_entity
    end
  end

  def recent_files
    @messages = Current.profile.conversation_messages.includes(:profile, :reactions).with_attached_message_attachments
  end

  def bench_channel_messages
    @conversation = @bench_channel.bench_conversation
    paginate_messages
  end

  def group_messages
    @conversation = @group.bench_conversation
    paginate_messages
  end

  def last_messages
    @last_messages = fetch_last_messages
  end

  def fetch_last_messages
    params[:dm_ids].filter_map do |id|
      BenchConversation.profile_to_profile_conversation(Current.profile.id, id)&.conversation_messages&.last
    end.sort_by(&:created_at).reverse
  end

  def profile_messages
    @conversation = BenchConversation.profile_to_profile_conversation(Current.profile.id, @receiver.id)
    create_conversation if @conversation.blank?
    paginate_messages
  end

  def create_conversation
    @conversation = BenchConversation.create(conversationable_type: 'Profile', conversationable_id: @receiver.id, sender_id: Current.profile.id)
  end

  def unread_messages
    str = REDIS.get("unreadMessages#{Current.workspace.id}#{Current.profile.id}")
    @previous_unread_messages_details = str.nil? ? {} : JSON.parse(str)
  end

  private

  def paginate_messages
    @pagy, @messages = pagination_for_chat_messages(@conversation.id, params[:page])

    return render json: { error: 'Page not Found.' }, status: :not_found if @pagy.nil?
  end

  def set_saved_item
    @saved_item = Current.profile.saved_items.find_by(conversation_message_id: params[:id])

    return render json: { message: 'Message Not Found.' }, status: :not_found if @saved_item.nil?
  end

  def set_message
    @message = ConversationMessage.find(params[:id])
  end

  def conversation_messages_params
    params.permit(:content, :is_threaded, :parent_message_id, :is_sent_to_chat, message_attachments: []).tap do |param|
      param[:sender_id] = @current_profile.id
    end
  end

  def schedule_messages_params
    params.permit(:content, :scheduled_at).tap do |param|
      param[:profile_id] = @current_profile.id
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
                            BenchConversation.profile_to_profile_conversation(Current.profile.id, conversation_id)
                          end
    render json: { error: 'wrong type' }, status: :bad_request if @bench_conversation.blank?
  end

  def set_bench_channel
    @bench_channel = BenchChannel.find(params[:id])
    return if !@bench_channel.is_private || Current.profile.bench_channel_ids.include?(@bench_channel.id)

    render json: { error: 'User is not part of this channel' }, status: :not_found
  end

  def set_group
    @group = Group.find(params[:id])
    render json: { error: 'User is not part of this group' }, status: :not_found unless @group.profile_ids.include?(Current.profile.id)
  end

  def set_receiver
    @receiver = Profile.find(params[:id])
    render json: { error: "You can't access this profile." }, status: :unprocessable_entity unless @receiver.workspace_id.eql?(Current.workspace.id)
  end

  def authenticat_message
    if @message.sender_id.eql?(Current.profile.id)
      check_membership(@message.bench_conversation)
    else
      render json: { error: 'Sorry, this message is not yours.' }, status: :unauthorized
    end
  end

  def verify_membership
    check_membership(@bench_conversation)
  end

  def marked_chat_read
    UnreadMessagesMarkedAsReadService.new(@conversation).call
  end

  def delete_parent_message?
    msg = 'This message was deleted.'
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
      @message.update!(content: 'This message was deleted.')
    end
  end
end
