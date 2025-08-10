# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  arrives_at  :datetime         not null
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  name        :string           not null
#  no_of_seats :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
# Indexes
#
#  index_flights_on_company_id                       (company_id)
#  multicolumn_index_flights_on_name_and_company_id  (lower((name)::text), company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
FactoryBot.define do
  factory :flight do
    name        { "Flight ##{Faker::Number.unique.number(digits: 5)}" }
    no_of_seats { rand(100..200) }
    base_price  { rand(100..200) }
    departs_at  { rand(5..15).days.from_now }
    arrives_at  { departs_at.next_day }
    company
  end
end
