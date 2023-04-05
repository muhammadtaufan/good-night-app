module V1
  class FollowsController < ApplicationController
    before_action :set_user, only: %i[create destroy]

    def create
      current_user = User.find(5)
      current_user.follow(@user)
      render json: { success: true, message: 'User followed' }
    end

    def destroy
      current_user = User.find(5)
      current_user.unfollow(@user)
      render json: { success: true, message: 'User unfollowed' }
    end

    private

    def set_user
      @user = User.find(params[:id])
    end
  end
end
