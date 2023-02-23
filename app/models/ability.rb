class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    profile ||= user.user_profile
    workspace = profile.workspace

    can %i[create destroy], Reaction do |reaction|
      check_ability(reaction, profile) && reaction.profile_id.eql?(profile.id)
    end

    can %i[destroy], Pin do |pin|
      check_ability(pin, profile)
    end

    can %i[create], Pin do |pin|
      check_ability_for_create(pin, profile)
    end

    can %i[update destroy], ConversationMessage do |message|
      check_ability(message, profile) && message.sender_id.eql?(profile.id)
    end

    can %i[create], ConversationMessage do |message|
      check_ability_for_message_create(message, profile)
    end

    can %i[create], ScheduleMessage do |message|
      check_ability_for_create(message, profile)
    end

    can %i[destroy update send_now], ScheduleMessage, profile_id: profile.id

    can %i[create update destroy], DraftMessage do |draft_message|
      check_ability_for_create(draft_message, profile)
    end

    can :destroy, Status, profile_id: profile.id
    can %i[create destroy], Download, profile_id: profile.id

    can %i[get add_member], Group do |group|
      group.profile_ids.include?(profile.id)
    end

    can %i[create destroy], Favourite do |favourite|
      favourite.profile_id.eql?(profile.id) && check_ability_for_favourite(
        get_conversation(favourite.favourable_type, favourite.favourable_id, profile.id), profile
      )
    end

    can %i[destroy], BenchChannel, creator_id: profile.id

    can %i[update], BenchChannel do |channel|
      channel.profile_ids.include?(profile.id)
    end

    can %i[get], BenchChannel do |channel|
      channel.is_private? ? channel.profile_ids.include?(profile.id) : true
    end

    can %i[leave_channel], ChannelParticipant, profile_id: profile.id

    can %i[destroy], SavedItem, profile_id: profile.id

    can %i[join_public_channel], BenchChannel do |channel|
      !channel.is_private? && channel.workspace_id.eql?(workspace.id)
    end
  end

  private

  def check_membership(bench_conversation, profile)
    profile_ids = if bench_conversation.conversationable_type.eql?('Profile')
                    [bench_conversation.conversationable_id, bench_conversation.sender_id]
                  else
                    bench_conversation.conversationable.profile_ids
                  end

    profile_ids.include?(profile.id)
  end

  def check_ability_for_create(object, profile)
    object.profile_id.eql?(profile.id) ? check_membership(object.bench_conversation, profile) : false
  end

  def check_ability_for_message_create(object, profile)
    object.sender_id.eql?(profile.id) ? check_membership(object.bench_conversation, profile) : false
  end

  def check_ability(object, profile)
    if object.bench_conversation.conversationable_type.eql?('BenchChannel')
      object.bench_conversation.conversationable.is_private ? check_membership(object.bench_conversation, profile) : true
    else
      check_membership(object.bench_conversation, profile)
    end
  end

  def get_conversation(favourable_type, favourable_id, profile_id)
    case favourable_type
    when 'BenchChannel'
      BenchConversation.get_bench_conversationable('BenchChannel', favourable_id).first
    when 'Group'
      BenchConversation.get_bench_conversationable('Group', favourable_id).first
    when 'Profile'
      BenchConversation.profile_to_profile_conversation(favourable_id, profile_id)
    end
  end

  def check_ability_for_favourite(conversation, profile)
    check_membership(conversation, profile)
  end
end
