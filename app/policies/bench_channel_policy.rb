class BenchChannelPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    !user.outsider?
  end

  def show?
    record.profile_ids.include?(user.id) || !user.outsider?
  end

  def create?
    !user.outsider?
  end

  def update?
    !user.outsider?
  end

  def destroy?
    !user.outsider?
  end

  def join_public_channel?
    !user.outsider?
  end
end
