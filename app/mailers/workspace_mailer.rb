class WorkspaceMailer < ApplicationMailer
  def send_email(email, workspace, token)
    @email = email
    @workspace = workspace
    @token = token
    mail(to: @email, subject: t('.workspace_invitation_subject', company_name: @workspace.company_name))
  end

  def send_workspace_create_mail(workspace, profile, user)
    @email = user.email
    @workspace = workspace
    @profile = profile
    mail(to: @email, subject: t('.workspace_create_subject'))
  end
end
