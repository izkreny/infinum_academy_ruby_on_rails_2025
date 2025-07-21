RSpec.describe User, type: :model do
  describe 'validations' do
    # let(:user) { FactoryBot.create(:user) }
    FakeUser.create

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@email.com').for(:email) } # rubocop:disable RSpec/ImplicitExpect
    it { should_not allow_value('jeff@amazon').for(:email) } # rubocop:disable RSpec/ImplicitExpect
    it { should_not allow_value('user_email.com').for(:email) } # rubocop:disable RSpec/ImplicitExpect
    it { should_not allow_value('user@email_com').for(:email) } # rubocop:disable RSpec/ImplicitExpect
  end

  describe 'associations' do
    it { is_expected.to have_many(:bookings).dependent(:destroy) }
    it { is_expected.to have_many(:flights).through(:bookings) }
  end
end
