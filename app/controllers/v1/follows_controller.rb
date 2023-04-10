module V1
  class FollowsController < ApplicationController
    before_action :set_user, only: %i[create destroy]

    def create
      message = current_user.follow(@user)

      if message == 'User followed'
        json_success_response(nil, :ok, message)
      elsif message == 'Already following this user'
        json_error_response(message, :unprocessable_entity)
      else
        json_error_response('Something wrong, please try again', :internal_server_error)
      end
    end

    def destroy
      current_user.unfollow(@user)
      json_success_response(nil, :ok, 'User unfollowed')
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
