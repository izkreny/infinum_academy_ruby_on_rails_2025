FactoryBot.define do
  factory :booking do
    no_of_seats { rand(1..3) }
    seat_price  { rand(100..200) }
    user
    flight
  end
end
