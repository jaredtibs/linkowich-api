class Api::V1::BaseController < ApplicationController

  def bad_request
    render json: { errors: ["bad request"] }, status: :bad_request
  end

  def unauthorized
    render json: { errors: ["unauthorized"] }, status: :unauthorized
  end

  def server_error
    render json: { errors: ["something went wrong"] }, status: :internal_server_error
  end

  def not_found
    render json: { errors: ["not found"] }, status: :not_found
  end

end
