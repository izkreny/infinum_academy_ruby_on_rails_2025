RSpec.describe Flight, type: :model do
  # let(:flight) { create(:flight) }
  company = Company.create(name: Faker::Company.unique.name)
  described_class.create(
    name: "Flight ##{Faker::Number.unique.hexadecimal(digits: 5)}",
    no_of_seats: 100,
    base_price: 111,
    departs_at: DateTime.now + 10,
    arrives_at: DateTime.now + 11,
    company: company
  )

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to(:company_id) }
    it { should validate_numericality_of(:no_of_seats).only_integer.is_greater_than(0) }
    it { should validate_numericality_of(:base_price).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:departs_at) }
    it { should validate_presence_of(:arrives_at) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:bookings).dependent(:destroy) }
    it { should have_many(:users).through(:bookings) }
  end

  describe 'business logic' do
    it 'departure time must be before the arrival time' do
      backward_flight = described_class.new(
        name: "Flight ##{Faker::Number.hexadecimal(digits: 5)}",
        no_of_seats: 100,
        base_price: 111,
        departs_at: DateTime.now + 11,
        arrives_at: DateTime.now + 10,
        company: company
      )
      expect(backward_flight.valid?).to be false
    end
  end
end
