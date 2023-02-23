class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    profile ||= user.user_profile

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
      check_ability(message, profile) && message.profile_id.eql?(profile.id)
    end

    can %i[create], ConversationMessage do |message|
      check_ability_for_create(message, profile)
    end

    can %i[create], ScheduleMessage do |message|
      check_ability_for_create(message, profile)
    end

    can %i[destroy send_now update], ScheduleMessage, profile_id: profile.id

    can %i[create update destroy], DraftMessage do |draft_message|
      check_ability_for_create(draft_message, profile)
    end

    can :destroy, Status, profile_id: profile.id
    can %i[create destroy], Download, profile_id: profile.id

    can %i[read add_member], Group do |group|
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

    can %i[read], BenchChannel do |channel|
      channel.is_private? ? channel.profile_ids.include?(profile.id) : true
    end

    can %i[leave_channel], ChannelParticipant, profile_id: profile.id




    can %i[joined_channels bench_channel_messages], BenchChannel do |channel|
      channel.profile_ids.include?(profile.id) || !profile.outsider?
    end

    unless profile.outsider?
      can :invite, Workspace
      can :read, :all
    end

    can %i[profile_messages show], Profile do |account|
      profile.eql?(account) || !profile.outsider?
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
      BenchConversation.where(conversationable_type: 'BenchChannel', conversationable_id: favourable_id)
    when 'Group'
      BenchConversation.where(conversationable_type: 'Group', conversationable_id: favourable_id)
    when 'Profile'
      BenchConversation.profile_to_profile_conversation(favourable_id, profile_id)
    end
  end

  def check_ability_for_favourite(conversation, profile)
    check_membership(conversation.first, profile)
  end
end
