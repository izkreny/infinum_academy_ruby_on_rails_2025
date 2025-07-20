FactoryBot.define do
  factory :user do
    sequence(:email)      { |n| "user-#{n}@email.com" }
    sequence(:first_name) { |n| "First name ##{n}" }
  end
end
