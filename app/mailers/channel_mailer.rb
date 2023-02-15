class ChannelMailer < ApplicationMailer
  def send_email(email, bench_channel, token)
    @email = email
    @bench_channel = bench_channel
    @workspace = @bench_channel.workspace
    @token = token
    mail(to: @email, subject: "Invitation to join #{@workspace.company_name}")
  end
end
