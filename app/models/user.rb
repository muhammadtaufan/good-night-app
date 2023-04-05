class User < ApplicationRecord
  has_many :time_events

  has_many :follows, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :follows, source: :followed

  has_many :followed, foreign_key: 'followed_id', class_name: 'Follow', dependent: :destroy
  has_many :followers, through: :followed, source: :follower

  validates :name, presence: true

  def follow(user)
    followed_users << user
  end

  def unfollow(user)
    followed_users.delete(user)
  end

  def following?(user)
    followed_users.include?(user)
  end
end
