# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer          not null
#  seat_price  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  flight_id   :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_bookings_on_flight_id  (flight_id)
#  index_bookings_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (flight_id => flights.id)
#  fk_rails_...  (user_id => users.id)
#
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
    context 'when departure time of the flight is in the past' do
      let!(:past_flight)                { create(:flight, departs_at: 10.days.ago) }
      let(:booking_for_the_past_flight) { build(:booking, flight: past_flight) }

      it { expect(booking_for_the_past_flight.valid?).to be false }
    end

    context 'when departure time of the flight is in the future' do
      let!(:regular_flight)                { create(:flight) }
      let(:booking_for_the_regular_flight) { build(:booking, flight: regular_flight) }

      it { expect(booking_for_the_regular_flight.valid?).to be true }
    end
  end
end
