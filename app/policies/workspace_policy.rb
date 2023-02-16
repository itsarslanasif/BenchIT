class WorkspacePolicy < ApplicationPolicy

  def create?
    !user.outsider?
  end

  def invite?
    create?
  end
end
