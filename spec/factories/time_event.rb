FactoryBot.define do
  factory :time_event do
    user_id { 1 }
    event_time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    is_time_in { true }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
