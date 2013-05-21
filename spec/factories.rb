FactoryGirl.define do
  factory :profile do
    association :user
  end

  factory :user do
    email       { Faker::Internet.email }
    password    { Devise.friendly_token }
  end

  factory :subprofile do
    provider    'linkedin'
    first_name  { Faker::Lorem.words.first.titleize }
    last_name   { Faker::Lorem.words.last.titleize }
    location    { Faker::Lorem.words.join(" ").titleize }
    identifier  { Random.rand(100000).to_s }
  end
end