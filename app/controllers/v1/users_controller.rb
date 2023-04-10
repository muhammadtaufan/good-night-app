module V1
  class UsersController < ApplicationController
    before_action :authenticate_user!, except: %i[create index]
    before_action :set_user, only: [:show]

    def index
      @users = User.all
      json_success_response(@users)
    end

    def show
      json_success_response(@user)
    end

    def create
      @user = User.new(user_params)

      if @user.save
        json_success_response(@user, :created)
      else
        json_error_response(@user.errors)
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
