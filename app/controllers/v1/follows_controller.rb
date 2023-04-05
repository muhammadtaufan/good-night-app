module V1
  class FollowsController < ApplicationController
    before_action :set_user, only: %i[create destroy]

    def create
      message = current_user.follow(@user)

      if message == 'User followed'
        render json: { success: true, message: message }
      else
        render json: { success: false, message: message }, status: :unprocessable_entity
      end
    end

    def destroy
      current_user.unfollow(@user)
      render json: { success: true, message: 'User unfollowed' }
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
