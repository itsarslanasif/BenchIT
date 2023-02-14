class ProfilePolicy < ApplicationPolicy
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
    !user.outsider? || user == record
  end

  def profile_messages?
    !user.outsider? || user == record
  end
end
