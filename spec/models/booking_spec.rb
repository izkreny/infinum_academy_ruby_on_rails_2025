RSpec.describe Booking, type: :model do
  # let(:booking) { create(:booking) }
  FakeBooking.create

  describe 'validations' do
    it { is_expected.to validate_presence_of(:no_of_seats) }
    it { is_expected.to validate_presence_of(:seat_price) }
    it { is_expected.to validate_numericality_of(:no_of_seats).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:seat_price).only_integer.is_greater_than(0) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:flight) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'business logic' do
    it 'departure time of the flight can not be in the past' do
      past_flight = FakeFlight.new
      past_flight.departs_at = DateTime.now - 10
      past_flight.arrives_at = past_flight.departs_at + 1
      booking_for_the_past_flight = FakeBooking.new
      booking_for_the_past_flight.flight = past_flight

      expect(booking_for_the_past_flight.valid?).to be false
    end
  end
end
