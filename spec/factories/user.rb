FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    auth_token { Faker::Alphanumeric.alphanumeric(number: 10) }
  end
end
