class Api::V1::InvitationsController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :find_invitation, only: :accept

  def create
    @invitation = current_user.invitations.build recipient_email: params[:email]
    if @invitation.save
      UserMailer.invitation_email(current_user, params[:email]).deliver_later
      render json: { success: "Invite sent" }, status: :ok
    else
      render json: { errors: "Unable to send invite" }, status: :unprocessable_entity
    end
  end

  def for_user
    @invitations = Invitation.where(recipient_email: current_user.email)
    render json: @invitations,
           meta: { count: @invitations.count },
           each_serializer: InvitationSerializer,
           status: :ok
  end

  def accept
    @sender = @invitation.sender

    if @sender.nil? || current_user.email != @invitation.recipient_email
      render json: { errors: ["Unable to accept invitation"] }, status: :unprocessable_entity
      return
    end

    if current_user.follow(@sender.id) && @sender.follow(current_user.id)
      @invitation.update_column :accepted, true
      render json: { success: "Friendship added" }, status: :ok
    end
  end

  private

  def find_invitation
    @invitation = Invitation.find params[:id]
  rescue
    not_found
  end
end
