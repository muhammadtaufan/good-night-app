class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def current_user
    return @current_user if @current_user

    token = request.headers['Authorization']
    @current_user = User.find_by(auth_token: token) if token.present?
  end

  private

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end
end
