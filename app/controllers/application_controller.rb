class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def not_found
    render json: { error: 'error' }, status: :not_found
  end
end
