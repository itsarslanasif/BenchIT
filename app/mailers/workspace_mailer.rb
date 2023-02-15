class WorkspaceMailer < ApplicationMailer
  def send_email(email, workspace, token)
    @email = email
    @workspace = workspace
    @token = token
    mail(to: @email, subject: t('.workspace_invitation_subject', company_name: @workspace.company_name))
  end
end
