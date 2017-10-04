class UserMailer < ApplicationMailer
  def app_invite(user, email)
    @user = user
    # TODO we probs want to add a full name to user for the specific benefit of having the friends name in the subject
    mail(to: email, subject: "#{@user.email} wants you to join Linkowhich")
  end
end
