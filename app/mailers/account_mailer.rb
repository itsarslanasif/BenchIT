class AccountMailer < ApplicationMailer
  def verification_email(user)
    @user = user
    end_point = "#{ENV.fetch('VITE_APP_SERVER_URL', nil)}api/v1/users/#{@user.id}/verify_email"
    @verification_link = "#{end_point}/?verification_token=#{@user.verification_token}"
    mail(to: @user.email, subject: t('.mail_subject'))
  end
end
