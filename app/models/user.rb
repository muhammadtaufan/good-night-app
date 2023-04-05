class User < ApplicationRecord
  has_many :time_events

  has_many :follows, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :follows, source: :followed

  has_many :followed, foreign_key: 'followed_id', class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :followed, source: :follower

  validates :name, presence: true

  before_create :generate_auth_token

  def follow(user)
    return 'Already following this user' if following?(user)

    followed_users << user
    'User followed'
  end

  def unfollow(user)
    followed_users.delete(user)
  end

  def following?(user)
    followed_users.include?(user)
  end

  def generate_auth_token
    loop do
      self.auth_token = SecureRandom.hex(20)
      break unless User.exists?(auth_token: auth_token)
    end
  end

  def weekly_event_summary(start_date)
    followed_users_ids = followed_users.pluck(:id)

    time_entries = TimeEvent
                   .includes(:user)
                   .where(user_id: followed_users_ids,
                          event_time: start_date.beginning_of_day..(start_date + 6.days).end_of_day).order(:event_time)
                   .pluck(
                     :id, :event_time
                   )

    time_entries.chunk_while { |prev, curr| prev[1].to_date == curr[1].to_date }.map do |entries|
      next if entries.size != 2

      (temp_id, time_in), (_, time_out) = entries

      {
        id: temp_id,
        duration: ((time_out - time_in) / 60).to_i,
        sleep_time: time_in,
        wake_up: time_out
      }
    end.compact.group_by { |entry| entry[:sleep_time].to_date }.transform_values do |entries|
      entries.sort_by do |entry|
        entry[:duration]
      end
    end
  end
end
