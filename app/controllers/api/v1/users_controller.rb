class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!, only: [
    :show,
    :search,
    :update,
    :update_email,
    :update_avatar,
    :follow,
    :unfollow,
    :followers,
    :following,
    :links
  ]

  before_action :find_user, only: [:show, :links]

  # profile
  def show
    if @user
      render json: @user, serializer: UserSerializer, status: :ok
    else
      render json: { errors: "User not found." }, status: :not_found
    end
  end

  def search
    query = params[:query] || nil
    users = User.where('username ILIKE ?', "#{query}%") if query
    result = users || []
    render json: result,
      meta: { count: result.count },
      each_serializer: UserSerializer,
      status: :ok
  end

  def update
    if current_user.update update_params
      render json: { success:  I18n.t('success.users.account_updated')}, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reset_password
    @user = User.find_by email: params[:email]

    if @user
      token = UserService.reset_password_for @user
      UserMailer.reset_password_email(@user, token).deliver_later
      render json: { success: I18n.t('success.users.reset_password_sent')}, status: :ok
    else
      render json: { errors: I18n.t('errors.user_not_found') }, status: :unprocessable_entity
    end
  end

  def update_password
    pass_token = Devise.token_generator.digest(
      User, :reset_password_token,
      update_password_params[:reset_password_token]
    )
    user = User.find_by reset_password_token: pass_token

    if user
      outcome = UserService.update_password_for(user, update_password_params)
      if outcome[:result] == "success"
        sign_in user
        render json: {token: outcome[:result][:token]}, status: :ok
      else
        render json: {errors: outcome[:result][:errors]}, status: :unprocessable_entity
      end
    else
      unauthorized
    end
  end

  def update_email
    password = update_email_params[:password]
    email = update_email_params[:email]

    if current_user.valid_password?(password)
      current_user.email = email
      if current_user.save
        render json: { success: "email updated" }, status: :ok
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: "invalid password" }, status: :forbidden
    end
  end

  def update_avatar
    current_user.image_data = avatar_params[:file]
    if current_user.save
      render json: current_user, serializer: UserSerializer, status: :ok
    else
      render json: {errors: "error updating avatar"}, status: :unprocessable_entity
    end
  end

  def follow
    followee = User.find_by id: params[:id]
    if followee and current_user.follow followee.id
      # send notification here
      render json: followee, serializer: FriendSerializer, status: :ok
    else
      render json: {errors: "unable to follow that user"}, status: :unprocessable_entity
    end
  end

  def unfollow
    followee = User.find_by id: params[:id]
    if followee and current_user.unfollow(followee.id)
      render json: followee, serializer: FriendSerializer, status: :ok
    else
      render json: {errors: "unable to unfollow that user" }, status: :unprocessable_entity
    end
  end

  def following
    render json: current_user.following,
      each_serializer: FriendSerializer,
      scope: current_user,
      scope_name: :current_user,
      status: :ok
  rescue
    render json: {errors: "something went wrong"}, status: :internal_server_error
  end

  def followers
    render json: current_user.followers,
      each_serializer: FriendSerializer,
      scope: current_user,
      scope_name: :current_user,
      status: :ok
  rescue
    render json: {errors: "something went wrong"}, status: :internal_server_error
  end

  def follow_by_code
    user_by_code = User.where(follow_code: params[:code]).first
    unless user_by_code
      render json: {errors: "no user found by that code"}, status: :not_found
      return
    end

    if current_user.follow(user_by_code.id) && user_by_code.follow(current_user.id)
      render json: current_user.following, each_serializer: UserSerializer, status: :ok
    else
      render json: {errors: "unable to follow using that code" }, status: :unprocessable_entity
    end
  end

  def links
    links = @user.links.visible.order('created_at desc')
    render json: links,
      meta: {count: links.count},
      each_serializer: LinkSerializer,
      scope: current_user,
      scope_name: :current_user,
      status: :ok
  rescue
    render json: {errors: "something went wrong"}, status: :internal_server_error
  end

  private

  def find_user
    if params[:id] == "me"
      @user = current_user
    else
      @user = User.find_by id: params[:id]
    end
  end

  def update_params
    params.permit(:username)
  end

  def reset_password_params
    params.require(:email)
    params.permit(:email)
  end

  def update_password_params
    params.require(
      :reset_password_token
    )
    params.permit(
      :user,
      :reset_password_token,
      :password,
      :password_confirmation
    )
  end

  def update_email_params
    params.require(:password, :email)
    params.permit(:password, :email)
  end

  def avatar_params
    params.require(:file)
    params.permit(
      :user,
      :file,
      :avatar_x,
      :avatar_y
    )
  end
end
