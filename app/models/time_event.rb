class TimeEvent < ApplicationRecord
  belongs_to :user
  validates :event_time, presence: true
  validates :is_time_in, inclusion: { in: [true, false] }

  def time_out?
    !is_time_in?
  end
end
