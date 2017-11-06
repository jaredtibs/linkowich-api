class Api::V1::NotificationsController < Api::V1::BaseController
  before_action :authenticate_user!

  def pusher_auth
    user_id = params[:channel_name].split("-").last

    if current_user and current_user.following.pluck(:id).include?(user_id)
      response = $pusher_client.authenticate(params[:channel_name], params[:socket_id])
      render json: response
    else
      render text: 'Forbidden', status: '403'
    end
  end

end
