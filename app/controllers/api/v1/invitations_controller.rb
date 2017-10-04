class Api::V1::InvitationsController < Api::V1::BaseController
  before_action :authenticate_user!

  def create
    invitation = Invitation.new(inviter_id: current_user.id, email: params[:email])
  end
end
