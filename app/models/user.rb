class User < ApplicationRecord
  has_many :time_events
  validates :name, presence: true
end
