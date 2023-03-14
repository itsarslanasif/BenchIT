class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    profile ||= Current.profile
    workspace = profile.workspace

    can %i[create destroy], Reaction do |reaction|
      reaction.profile_id.eql?(profile.id) && check_ability(reaction.bench_conversation, profile)
    end

    can %i[destroy], Pin do |pin|
      check_ability(pin.bench_conversation, profile)
    end

    can %i[create], Pin do |pin|
      check_membership(pin.bench_conversation, profile)
    end

    can %i[update destroy], ConversationMessage do |message|
      message.sender_id.eql?(profile.id) && check_ability(message.bench_conversation, profile)
    end

    can %i[create], ConversationMessage do |message|
      check_membership(message.bench_conversation, profile)
    end

    can %i[create], ScheduleMessage do |message|
      check_membership(message.bench_conversation, profile)
    end

    can %i[destroy update send_now], ScheduleMessage, profile_id: profile.id

    can %i[create update destroy], DraftMessage do |message|
      message.profile_id.eql?(profile.id) && check_membership(message.bench_conversation, profile)
    end

    can :destroy, Status, profile_id: profile.id

    can %i[create destroy], Download, profile_id: profile.id

    can %i[get add_member], Group do |group|
      group.profile_ids.include?(profile.id)
    end

    can %i[destroy], BenchChannel, creator_id: profile.id

    can %i[update], BenchChannel do |channel|
      channel.profile_ids.include?(profile.id)
    end

    can %i[get], BenchChannel do |channel|
      channel.is_private? ? channel.profile_ids.include?(profile.id) : true
    end

    can %i[leave_channel], ChannelParticipant, profile_id: profile.id

    can %i[destroy], ChannelParticipant do |participant|
      user = participant.bench_channel.channel_participants.find_by!(profile_id: profile.id)
      user.channel_manager?
    end

    can %i[destroy], SavedItem, profile_id: profile.id

    can %i[join_public_channel], BenchChannel, { is_private: false, workspace: { id: workspace.id } }

    can %i[create destroy], Favourite do |favourite|
      conversation = get_conversation(favourite.favourable_type, favourite.favourable_id, profile.id)
      favourite.profile_id.eql?(profile.id) && check_membership(conversation, profile)
    end
  end

  private

  def check_membership(conversation, profile)
    profile_ids = if conversation.conversationable_type.eql?('Profile')
                    [conversation.conversationable_id, conversation.sender_id]
                  else
                    conversation.conversationable.profile_ids
                  end

    profile_ids.include?(profile.id)
  end

  def check_ability(conversation, profile)
    conversationable = conversation.conversationable
    if conversation.conversationable_type.eql?('BenchChannel')
      conversationable.is_private ? check_membership(conversation, profile) : true
    else
      check_membership(conversation, profile)
    end
  end

  def get_conversation(favourable_type, favourable_id, profile_id)
    if favourable_type.eql?('Profile')
      BenchConversation.profile_to_profile_conversation(favourable_id, profile_id)
    else
      BenchConversation.get_bench_conversation(favourable_type, favourable_id)
    end
  end
end
