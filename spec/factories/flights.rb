FactoryBot.define do
  factory :flight do
    sequence(:name) { |n| "Flight ##{n}" }
    no_of_seats { 100 }
    base_price { 111 }
    departs_at { DateTime.now + 10 }
    arrives_at { DateTime.now + 11 }
    company { create(:company) }
  end
end
