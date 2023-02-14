class BenchConversationPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def bench_channel_messages?
    !user.outsider? || record.conversationable.profile_ids.include?(user.id)
  end
end
