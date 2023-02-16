class ProfilePolicy < ApplicationPolicy

  def index?
    !user.outsider?
  end

  def show?
    index? || user.eql?(record)
  end

  def profile_messages?
    show?
  end
end
