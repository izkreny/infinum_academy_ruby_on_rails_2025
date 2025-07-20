RSpec.describe Flight, type: :model do
  # let(:flight) { create(:flight) }
  FakeFlight.create

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:company_id) }
    it { is_expected.to validate_numericality_of(:no_of_seats).only_integer.is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:base_price).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:departs_at) }
    it { is_expected.to validate_presence_of(:arrives_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:bookings).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:bookings) }
  end

  describe 'business logic' do
    it 'departure time must be before the arrival time' do
      backward_flight = FakeFlight.new
      backward_flight.departs_at = backward_flight.arrives_at + 1
      expect(backward_flight.valid?).to be false
    end
  end
end
