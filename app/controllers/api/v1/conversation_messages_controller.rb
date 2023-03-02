class Api::V1::ConversationMessagesController < Api::ApiController
  include MemberShip
  include Conversation
  include Pagination
  include CanAuthorization

  before_action :fetch_conversation, only: %i[create]
  before_action :set_message, :authenticate_message, only: %i[destroy update]
  before_action :set_bench_channel, only: %i[bench_channel_messages]
  before_action :set_group, only: %i[group_messages]
  before_action :set_receiver, only: %i[profile_messages]
  before_action :authenticate, only: %i[bench_channel_messages group_messages]
  after_action :marked_chat_read, only: %i[bench_channel_messages profile_messages group_messages]

  def sent_message
    @pagy, @sent_messages = pagination_for_sent_messages(params[:page])
  end

  def reactions_and_mentions
    @messages = mentioned_messages + current_profile.conversation_messages.messages_with_other_reactions(current_profile)
  end

  def create
    if params[:scheduled_at].blank?
      @message = @bench_conversation.conversation_messages.new(conversation_messages_params)
      ActiveRecord::Base.transaction do
        @message.save!
        if params[:profile_list].present?
          params[:profile_list].each do |profile_id|
            @message.mentions.create!(mentionable_type: 'Profile', mentionable_id: profile_id)
          end
        end
      end

      authorize! :create, @message
      @message.save!

      render json: { success: true, message: t('.success') }, status: :ok
    else
      @schedule_message = @bench_conversation.schedule_messages.new(schedule_messages_params)
      authorize! :create, @schedule_message
      @schedule_message.save!
    end
  end

  def update
    @message.update!(conversation_messages_params)
    render json: { success: true, message: t('.success') }, status: :ok
  end

  def destroy
    if delete_parent_message?
      delete_reply_and_parent_message
    elsif soft_delete_message?
      soft_delete_message
    else
      @message.destroy!
    end

    render json: { success: true, message: t('.success') }, status: :ok
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
    create_direct_messages
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

    return render json: { success: false, error: t('.failure') }, status: :not_found if @pagy.nil?
  end

  def set_message
    @message = ConversationMessage.find(params[:id])
  end

  def conversation_messages_params
    params.permit(:content, :is_threaded, :parent_message_id, :is_sent_to_chat, :shared_message_id, message_attachments: []).tap do |param|
      param[:sender_id] = current_profile.id
    end
  end

  def schedule_messages_params
    params.permit(:content, :scheduled_at).tap do |param|
      param[:profile_id] = current_profile.id
    end
  end

  def fetch_conversation
    @bench_conversation = get_conversation(params[:conversation_id], params[:conversation_type])
  end

  def set_bench_channel
    @bench_channel = BenchChannel.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def authenticate
    action_name.eql?('group_messages') ? (authorize! :get, @group) : (authorize! :get, @bench_channel)
  end

  def set_receiver
    @receiver = Profile.find(params[:id])

    return if @receiver.workspace_id.eql?(current_workspace.id)

    render json: { success: false, error: t('.failure') }, status: :unprocessable_entity
  end

  def authenticate_message
    authorize_action(action_name, @message)
  end

  def marked_chat_read
    UnreadMessagesMarkedAsReadService.new(@conversation).call
  end

  def delete_parent_message?
    @message.parent_message&.content.eql?(t('.delete_text')) && @message.parent_message.replies.count.eql?(1)
  end

  def delete_reply_and_parent_message
    ActiveRecord::Base.transaction do
      @message.pin&.destroy!
      @message.destroy!
      @message.parent_message.destroy!
    end
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

  def create_direct_messages
    current_profile.direct_message_users.find_or_create_by!(receiver_id: @receiver.id)
    @receiver.direct_message_users.find_or_create_by!(receiver_id: current_profile.id)
  end

  def mentioned_messages
    ConversationMessage.where(id: current_profile.mentions.pluck(:conversation_message_id)).where.not(sender_id: current_profile.id)
  end
end
