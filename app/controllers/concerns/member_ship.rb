module MemberShip
  extend ActiveSupport::Concern

  def check_membership(bench_conversation)
    profile_ids = if bench_conversation.conversationable_type.eql?('Profile')
                    [bench_conversation.conversationable_id, bench_conversation.sender_id]
                  else
                    bench_conversation.conversationable.profile_ids
                  end

    return if profile_ids.include?(current_profile.id)

    render json: { success: false, message: I18n.t('concerns.membership.error') }, status: :unauthorized
  end
end
