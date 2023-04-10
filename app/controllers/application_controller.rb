class ApplicationController < ActionController::API
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def current_user
    return @current_user if @current_user

    token = request.headers['Authorization']
    @current_user = User.find_by(auth_token: token) if token.present?
  end

  private

  def authenticate_user!
    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end

  def json_success_response(data = nil, status = :ok, message = nil)
    response_body = { success: true }

    response_body[:data] = data if data.present?
    response_body[:message] = message if message.present?

    render json: response_body, status: status
  end

  def json_error_response(message, status = :unprocessable_entity)
    render json: { success: false, message: message }, status: status
  end

  def record_not_found
    json_error_response('Data not found', :not_found)
  end
end
