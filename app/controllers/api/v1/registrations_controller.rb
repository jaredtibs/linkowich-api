class Api::V1::RegistrationsController < Api::V1::BaseController

  def create
    user = User.new registration_params
    if user.save
      token = UserService.generate_token_for user
      sign_in user
      UserMailer.welcome_email(user).deliver_later
      render json: { token: token, user: ActiveModelSerializers::SerializableResource.new(user, serializer: UserSerializer)}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def registration_params
    params.require(:email)
    params.require(:password)
    params.permit(:email, :password, :username)
  end
end
