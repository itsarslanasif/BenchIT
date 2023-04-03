class WorkspaceMailer < ApplicationMailer
  def send_workspace_create_mail(workspace, profile, user)
    @email = user.email
    @workspace = workspace
    @profile = profile
    mail(to: @email, subject: t('.workspace_create_subject'))
  end

  def workspace_invitation_mail(invitable)
    @email = invitable.email
    @workspace = invitable.workspace
    @profile = invitable.profile
    @invitable = invitable
    end_point = "#{ENV.fetch('VITE_APP_SERVER_URL', nil)}api/v1/invitables/#{@invitable.id}/accept_invitation"
    @invitation_link = "#{end_point}/?token=#{@invitable.token}"
    mail(to: @email, subject: t('.workspace_invitation_subject', company_name: @workspace.company_name))
  end
end
