class UserMailer < ApplicationMailer
  def app_invite(user, email)
    @user = user
    mail(to: email, subject: "#{@user.email} wants you to join Linkowhich")
  end
end
