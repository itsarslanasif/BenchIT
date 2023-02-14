class WorkspacePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    !user.outsider?
  end

  def invite?
    !user.outsider?
  end
end
