FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password "Password"
    uid "abc123"
    twitter_token "abc"
    twitter_secret "123"
  end
end
