class BenchChannelPolicy < ApplicationPolicy
  def index?
    !user.outsider?
  end

  def show?
    record.profile_ids.include?(user.id) || index?
  end

  def create?
    index?
  end

  def update?
    index?
  end

  def destroy?
    index?
  end

  def join_public_channel?
    index?
  end

  def bench_channel_messages?
    show?
  end
end
