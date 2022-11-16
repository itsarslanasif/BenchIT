class SendWorkspaceInvitationEmailJob < ApplicationJob
  queue_as :default

  def perform(email, workspace)
    WorkspaceMailer.send_email(email,workspace).deliver!
  end
end
