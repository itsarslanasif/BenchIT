class SendWorkspaceInvitationEmailJob < ApplicationJob
  queue_as :default

  def perform(email, workspace, token)
    WorkspaceMailer.send_email(email, workspace, token).deliver!
  end
end
