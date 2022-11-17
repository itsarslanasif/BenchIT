class SendWorkspaceInvitationEmailJob < ApplicationJob
  queue_as :default

  def perform(email, workspace, token)
    puts 'in job'
    WorkspaceMailer.send_email(email, workspace, token).deliver!
  end
end
