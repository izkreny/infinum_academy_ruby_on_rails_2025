FactoryBot.define do
  factory :company do
    sequence(:name) { |n| "Company ##{n}" }
  end
end

module FakeCompany
  def self.create
    Company.create(name: Faker::Company.unique.name)
  end
end
