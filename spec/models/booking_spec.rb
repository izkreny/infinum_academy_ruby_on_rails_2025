RSpec.describe Booking, type: :model do
  # let(:booking) { create(:booking) }
  company = Company.create(name: Faker::Company.unique.name)
  user = User.create(
    first_name: Faker::Name.unique.first_name,
    email: Faker::Internet.unique.email
  )
  flight = Flight.create(
    name: "Flight ##{Faker::Number.unique.hexadecimal(digits: 5)}",
    no_of_seats: 100,
    base_price: 111,
    departs_at: DateTime.now + 10,
    arrives_at: DateTime.now + 11,
    company: company
  )
  described_class.create(
    no_of_seats: 1,
    seat_price: 111,
    user: user,
    flight: flight
  )

  describe 'validations' do
    it { should validate_presence_of(:no_of_seats) }
    it { should validate_presence_of(:seat_price) }
    it { should validate_numericality_of(:no_of_seats).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:seat_price).only_integer.is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:flight) }
    it { should belong_to(:user) }
  end

  describe 'business logic' do
    it 'departure time of the flight can not be in the past' do
      past_flight = Flight.create(
        name: "Flight ##{Faker::Number.hexadecimal(digits: 5)}",
        no_of_seats: 100,
        base_price: 111,
        departs_at: DateTime.now - 10,
        arrives_at: DateTime.now - 11,
        company: company
      )
      booking_for_the_past_flight = described_class.new(
        no_of_seats: 1,
        seat_price: 111,
        user: user,
        flight: past_flight
      )
      expect(booking_for_the_past_flight.valid?).to be false
    end
  end
end
