class ChannelParticipantPolicy < ApplicationPolicy
  def create?
    !user.outsider?
  end
end
