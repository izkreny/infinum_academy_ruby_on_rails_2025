RSpec.describe Booking, type: :model do
  subject { create(:booking) }

  describe 'validation' do
    it { is_expected.to validate_presence_of(:no_of_seats) }
    it { is_expected.to validate_presence_of(:seat_price) }
    it { is_expected.to validate_numericality_of(:no_of_seats).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:seat_price).only_integer.is_greater_than(0) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:flight) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'business logic' do
    it 'is sad if departure time of the flight is in the past' do
      past_flight = create(:flight, departs_at: 10.days.ago)
      booking_for_the_past_flight = build(:booking, flight: past_flight)
      expect(booking_for_the_past_flight.valid?).to be false
    end

    it 'is happy if departure time of the flight is in the future' do
      regular_flight = create(:flight)
      booking_for_the_regular_flight = build(:booking, flight: regular_flight)
      expect(booking_for_the_regular_flight.valid?).to be true
    end
  end
end
