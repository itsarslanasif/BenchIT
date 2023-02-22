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

    can %i[show joined_channels bench_channel_messages], BenchChannel do |channel|
      channel.profile_ids.include?(profile.id) || !profile.outsider?
    end

    can :leave_channel, BenchChannel do |channel|
      channel.profile_ids.include?(profile.id)
    end

    unless profile.outsider?
      can %i[create update destroy], BenchChannel
      can %i[create join_public_channel], ChannelParticipant
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
end
