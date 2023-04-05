class TimeEvent < ApplicationRecord
  belongs_to :user
  validates :event_time, presence: true
  validates :is_time_in, inclusion: { in: [true, false] }

  def wake_up?
    !is_time_in?
  end

  def sleep_time?
    is_time_in?
  end
end
