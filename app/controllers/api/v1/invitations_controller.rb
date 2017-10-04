class Api::V1::InvitationsController < Api::V1::BaseController
  before_action :authenticate_user!

  def create
    @invitation = current_user.invitations.build recipient_email: params[:email]
    if @invitation.save
      UserMailer.app_invite(current_user, params[:email]).deliver_later
      render json: { success: "Invite sent" }, status: :ok
    else
      render json: { errors: "Unable to send invite" }, status: :unprocessable_entity
    end
  end
end
