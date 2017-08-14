class Api::V1::LinksController < Api::V1::BaseController
  before_action :authenticate_user!

  def create
    @link = current_user.links.build link_params
    @link.current = true
    if @link.save
      current_user.links.where.not(id: @link.id).update_all current: false
      render json: @link, serializer: LinkSerializer, status: :created
    else
      render json: {errors: @link.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def current
    @current_link = current_user.current_link
    if @current_link
      render json: @current_link, serializer: LinkSerializer, status: :ok
    else
      render json: {message: "no link published"}, status: :ok
    end
  end

  def feed
    @following = current_user.following
    render json: @following,
      meta: {count: @following.count},
      each_serializer: UserSerializer,
      status: :ok
  end

  # unused
  def for_user
    @links = current_user.following_links
    render json: @links,
      meta: {count: @links.count},
      each_serializer: LinkSerializer,
      scope: current_user,
      scope_name: :current_user,
      status: :ok
  end

  private

  def link_params
    params.require(:url)
    params.permit(:url)
  end

end
