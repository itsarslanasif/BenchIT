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
    @message = ConversationMessage.new(conversation_messages_params)
    @message.bench_conversation_id = @bench_conversation.id
    response = if @message.save
                 { message: 'Message sent.' }
               else
                 { message: @message.errors, status: :unprocessable_entity }
               end
    render json: response
  end

  def update
    if @message.update(conversation_messages_params)
      render json: { success: 'Messages updated', message: @message, status: :updated }
    else
      render json: { errors: @message.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    if @message.parent_message_id && @message.parent_message.content.eql?(nil) && @message.replies.count.eql?(1)
      @message.parent_message.destroy!
    elsif @message.parent_message_id && @message.parent_message.content.eql?(nil) && @message.replies.count > 1
      @message.destroy!
    elsif @message.parent_message_id && !@message.parent_message.content.eql?(nil)
      @message.destroy!
    elsif @message.replies.count.positive?
      @message.update!(content: nil)
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

    render json: @saved_item.save ? { json: 'added to saved items' } : @saved_item.errors
  end

  def unsave_message
    render json: @saved_item.destroy ? { json: 'Removed from saved items' } : @saved_item.errors
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

    return render json: { errors: 'Page not Found.', status: :unprocessable_entity } if @pagy.nil?
  end

  def set_saved_item
    @saved_item = Current.profile.saved_items.find_by(conversation_message_id: params[:id])

    return render json: { message: 'Message Not Found.' }, status: :not_found if @saved_item.nil?
  end

  def set_message
    @message = ConversationMessage.find(params[:id])
  end

  def conversation_messages_params
    params.permit(:content, :is_threaded, :parent_message_id, message_attachments: []).tap do |param|
      param[:sender_id] = Current.profile.id
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

    render json: { message: 'wrong type', status: :unprocessable_entity } if @bench_conversation.blank?
  end

  def set_bench_channel
    @bench_channel = BenchChannel.find(params[:id])
    render json: { json: 'user is not part of this channel', status: :not_found } unless Current.profile.bench_channel_ids.include?(@bench_channel.id)
  end

  def set_group
    @group = Group.find(params[:id])
    render json: { json: 'user is not part of this group', status: :not_found } unless @group.profile_ids.include?(Current.profile.id)
  end

  def set_receiver
    @receiver = Profile.find(params[:id])
    render json: { message: "You can't access this profile.", status: :unprocessable_entity } unless @receiver.workspace_id.eql?(Current.workspace.id)
  end

  def authenticat_message
    if @message.sender_id.eql?(Current.profile.id)
      check_membership(@message.bench_conversation)
    else
      render json: { message: 'Sorry, this message is not your', status: :unprocessable_entity }
    end
  end

  def verify_membership
    check_membership(@bench_conversation)
  end

  def marked_chat_read
    UnreadMessagesMarkedAsReadService.new(@conversation).call
  end
end
