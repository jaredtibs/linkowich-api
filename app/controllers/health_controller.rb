class HealthController < ApplicationController

  def ping
    render json: {api_active: true}
  end
end
