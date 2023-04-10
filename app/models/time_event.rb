class TimeEvent < ApplicationRecord
  belongs_to :user
  validates :event_time, presence: true
  validates :is_time_in, inclusion: { in: [true, false] }
  validate :wake_up_always_have_sleep_time, on: :create

  def wake_up?
    !is_time_in?
  end

  def sleep_time?
    is_time_in?
  end

  def wake_up_always_have_sleep_time
    return if event_time.blank? || sleep_time?

    latest_sleep = TimeEvent.where(is_time_in: true)
                            .where('event_time < ?', event_time)
                            .order(event_time: :desc)
                            .last

    errors.add(:event_time, 'No sleep time found before this wake up time!') if latest_sleep.nil?
  end
end
