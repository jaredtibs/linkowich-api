class Api::V1::BaseController < ApplicationController

  def bad_request
    render json: { errors: I18n.t('errors.unauthorized') }, status: :bad_request
  end

  def unauthorized
    render json: { errors: I18n.t('errors.unauthorized') }, status: :unauthorized
    return false
  end

  def server_error
    render json: { errors: I18n.t('errors.server_error') }, status: :internal_server_error
  end

  def not_found
    render json: { errors: I18n.t('errors.not_found') }, status: :not_found
  end

end
