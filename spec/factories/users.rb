FactoryBot.define do
  factory :user do
    sequence(:email)      { |n| "user-#{n}@email.com" }
    sequence(:first_name) { |n| "First name ##{n}" }
  end
end

module FakeUser
  def self.create
    User.create(
      first_name: Faker::Name.unique.first_name,
      email: Faker::Internet.unique.email
    )
  end
end
