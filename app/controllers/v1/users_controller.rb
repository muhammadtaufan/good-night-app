module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: [:create]
    before_action :set_user, only: [:show]

    def index
      @users = User.all
      render json: { success: true, data: @users }
    end

    def show
      render json: { success: true, data: @user }
    end

    def create
      @user = User.new(user_params)

      if @user.save
        render json: { success: true, data: @user }, status: :created
      else
        render json: { success: true, message: @user.errors }, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name)
    end
  end
end
