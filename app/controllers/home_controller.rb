class HomeController < ActionController::API
  def render_401
    render json: { error: "unauthorized" }, status: :unauthorized 
  end
end