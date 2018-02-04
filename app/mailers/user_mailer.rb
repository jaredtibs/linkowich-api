class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Linkowich!")
  end

  def invitation_email(user, invitee_email)
    @user = user
    mail(to: invitee_email, subject: "#{@user.email} has invited you to join Linkowich!")
  end

  def reset_password_email(user, token)
    @user  = user
    @token = token
    @website_url = ENV['RESET_PSWD_URL']
    mail(to: @user.email, subject: "Reset password request received for Linkowich.")
  end
end
