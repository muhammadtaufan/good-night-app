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
end
