class Api::V1::ConversationMessagesController < Api::ApiController
  before_action :fetch_conversation, only: %i[create]
  before_action :set_message, only: %i[destroy update]
  before_action :set_saved_item, only: %i[unsave_message]
  before_action :set_bench_channel, only: %i[bench_channel_messages]
  before_action :set_group, only: %i[group_messages]
  before_action :set_receiver, only: %i[profile_messages]

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
    render json: @message.destroy ? { message: 'Message deleted successfully.' } : { message: @message.errors, status: :unprocessable_entity }
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
    @messages = @bench_channel.bench_conversation.conversation_messages.where(parent_message_id: nil).includes(:profile, :replies,
                                                                                                               :reactions).with_attached_message_attachments
  end

  def group_messages
    @messages = @group.bench_conversation.conversation_messages.includes(:profile, :reactions).with_attached_message_attachments
  end

  def profile_messages
    conversation = BenchConversation.profile_to_profile_conversation(Current.profile.id, @receiver.id)

    if conversation.blank?
      conversation = BenchConversation.create(conversationable_type: 'Profile', conversationable_id: @receiver.id, sender_id: Current.profile.id)
    end

    @messages = conversation.conversation_messages.includes(:profile, :reactions).with_attached_message_attachments
  end

  def unread_messages
    str = REDIS.get("unreadMessages#{Current.workspace.id}#{Current.profile.id}")
    previous_unread_messages_details = str.nil? ? [] : JSON.parse(str)
    unread_messages_ids = previous_unread_messages_details.pluck('message_id')
    @messages = ConversationMessage.messages_by_ids_array(unread_messages_ids)
                                   .includes(:reactions, :replies, :parent_message, :saved_items)
                                   .with_attached_message_attachments
  end

  private

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
end
