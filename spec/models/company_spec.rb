RSpec.describe Company, type: :model do
  # let(:company) { create(:company) }
  described_class.create(name: Faker::Company.unique.name)

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { should have_many(:flights).dependent(:destroy) }
    it { should have_many(:bookings).through(:flights) }
  end
end
