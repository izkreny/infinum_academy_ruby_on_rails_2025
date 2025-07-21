FactoryBot.define do
  factory :flight do
    name        { "Flight ##{Faker::Number.unique.number(digits: 5)}" }
    no_of_seats { rand(50..100) }
    base_price  { rand(100..200) }
    departs_at  { rand(5..15).days.from_now }
    arrives_at  { departs_at.next_day }
    company
  end
end
