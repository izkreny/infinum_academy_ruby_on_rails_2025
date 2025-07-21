RSpec.describe Flight, type: :model do
  subject { create(:flight) }

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:company_id) }
    it { is_expected.to validate_numericality_of(:no_of_seats).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:base_price).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:departs_at) }
    it { is_expected.to validate_presence_of(:arrives_at) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:bookings).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:bookings) }
  end

  describe 'business logic' do
    it 'is sad if departure time is after the arrival time' do
      backward_flight = build(
        :flight,
        departs_at: 11.days.from_now,
        arrives_at: 10.days.from_now
      )
      expect(backward_flight.valid?).to be false
    end

    it 'is happy if departure time is before the arrival time' do
      regular_flight = build(:flight)
      expect(regular_flight.valid?).to be true
    end
  end
end
