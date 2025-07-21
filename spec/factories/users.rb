FactoryBot.define do
  factory :user do
    first_name { Faker::Name.unique.first_name }
    email      { Faker::Internet.unique.email(name: first_name) }
  end
end
