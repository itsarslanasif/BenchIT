class WorkspaceMailer < ApplicationMailer

  def send_email(email, workspace)
    @email = email
    @workspace = workspace
    mail(to: @email, subject:"Invitation to join #{@workspace.company_name}")
  end
end
