class Api::V1::LinksController < Api::V1::BaseController
  before_action :authenticate_user!
  before_action :find_link, only: [:mark_as_seen, :upvote, :unvote]

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

  def clear_current
    if current_user.clear_current_link
      render json: { success: true, message: "link successfully cleared" }, status: :ok
    else
      render json: { errors: ["unable to clear link"] }, status: :unprocessable_entity
    end
  end

  def feed
    @links = current_user.following_links
    render json: @links,
      meta: {count: @links.count},
      each_serializer: LinkSerializer,
      scope: current_user,
      scope_name: :current_user,
      status: :ok
  end

  def clear_history
    if current_user.links.destroy_all
      render json: { success: "Link history cleared." }, status: :ok
    else
      render json: { errors: "Unable to clear link history" }, status: :unprocessable_entity
    end
  end

  def mark_as_seen
    @link.seen_by |= [current_user.id]
    if @link.save
      render json: { success: "Link #{@link.id} marked as seen" }, status: :ok
    else
      render json: { errors: @link.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def upvote
    if current_user.upvote(@link)
      @link.reload
      render json: @link, serializer: LinkSerializer, status: :ok
    else
      render json: {errors: "unable to upvote link"}, status: :unprocessable_entity
    end
  end

  def unvote
    if current_user.unvote(@link)
      @link.reload
      render json: @link, serializer: LinkSerializer, status: :ok
    else
      render json: {errors: "unable to unvote vote"}, status: :unprocessable_entity
    end
  end

  private

  def find_link
    @link = Link.find params[:id]
  rescue
    render json: { errors: "Link not found." }, status: :ok and return
  end

  def link_params
    params.require(:url)
    params.permit(:url)
  end

end
