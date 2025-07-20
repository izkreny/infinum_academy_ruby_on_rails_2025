FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "Flight ##{n}" }
    no_of_seats { 100 }
    base_price { 10 }
    departs_at { DateTime.now + 10 }
    arrives_at { DateTime.now + 11 }
    company { create(:company) }
  end
end

module FakeFlight
  def self.new
    Flight.new(
      name: "Flight [#{Faker::Number.unique.hexadecimal(digits: 5)}]",
      no_of_seats: 100,
      base_price: 10,
      departs_at: DateTime.now + 10,
      arrives_at: DateTime.now + 11,
      company: FakeCompany.create
    )
  end

  def self.create
    flight = new
    flight.save
    flight
  end
end
