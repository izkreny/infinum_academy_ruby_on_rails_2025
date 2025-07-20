RSpec.describe Company, type: :model do
  # let(:company) { create(:company) }
  FakeCompany.create

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'associations' do
    it { is_expected.to have_many(:flights).dependent(:destroy) }
    it { is_expected.to have_many(:bookings).through(:flights) }
  end
end
