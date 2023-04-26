class ApplicationController < ActionController::API
  def render_404
    render json: { not_found_route: request.original_url }, status: :not_found 
  end
end
