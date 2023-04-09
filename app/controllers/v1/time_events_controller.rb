module V1
  class TimeEventsController < ApplicationController
    before_action :set_time_event, only: [:show]

    def index
      @time_events = current_user.time_events.order(:created_at)
      json_success_response(@time_events)
    end

    def sleep
      @time_event = current_user.time_events.new(time_event_params)
      @time_event.is_time_in = true

      if @time_event.save
        json_success_response(@time_event, :created)
      else
        json_error_response(@time_event.errors, :unprocessable_entity)
      end
    end

    def wake_up
      @time_event = current_user.time_events.new(time_event_params)
      @time_event.is_time_in = false

      if @time_event.save
        json_success_response(@time_event, :created)
      else
        json_error_response(@time_event.errors, :unprocessable_entity)
      end
    end

    def show
      json_success_response(@time_event)
    end

    def weekly_time_summary
      start_date = params[:start_date].to_date
      event_weekly_summaries = current_user.weekly_event_summary(start_date)

      json_success_response(event_weekly_summaries)
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
