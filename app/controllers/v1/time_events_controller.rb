module V1
  class TimeEventsController < ApplicationController
    before_action :set_time_event, only: [:show]

    def index
      @time_events = current_user.time_events.order(:created_at)
      render json: { success: true, data: @time_events }
    end

    def sleep
      @time_event = current_user.time_events.new(time_event_params)
      @time_event.is_time_in = true

      if @time_event.save
        render json: { success: true, data: @time_event }, status: :created
      else
        render json: { success: false, message: @time_event.errors }, status: :unprocessable_entity
      end
    end

    def wake_up
      @time_event = current_user.time_events.new(time_event_params)
      @time_event.is_time_in = false

      if @time_event.save
        render json: { success: true, data: @time_event }, status: :created
      else
        render json: { success: false, message: @time_event.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: { success: true, data: @time_event }
    end

    def weekly_time_summary
      start_date = params[:start_date].to_date
      event_weekly_summaries = current_user.weekly_event_summary(start_date)

      render json: { success: true, data: event_weekly_summaries }
    end

    private

    def set_time_event
      @time_event = TimeEvent.find(params[:id])
    end

    def time_event_params
      params.require(:time_event).permit(:event_time)
    end
  end
end
