module V1
  class TimeEventsController < ApplicationController
    before_action :set_user
    before_action :set_time_event, only: [:show]

    def index
      @time_events = @user.time_events.order(:created_at)
      render json: @time_events
    end

    def create
      @time_event = @user.time_events.new(time_event_params)

      if @time_event.save
        render json: @time_event, status: :created
      else
        render json: @time_event.errors, status: :unprocessable_entity
      end
    end

    def show
      render json: @time_event
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_time_event
      @time_event = TimeEvent.find(params[:id])
    end

    def time_event_params
      params.require(:time_event).permit(:event_time, :is_time_in)
    end
  end
end
