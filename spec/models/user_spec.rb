RSpec.describe User, type: :model do
  describe 'validations' do
    # let(:user) { FactoryBot.create(:user) }
    described_class.create(
      first_name: Faker::Name.unique.first_name,
      email: Faker::Internet.unique.email
    )

    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_least(2) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@email.com').for(:email) }
    it { should !allow_value('user_email.com').for(:email) }
    it { should !allow_value('user@email_com').for(:email) }
  end

  describe 'associations' do
    it { should have_many(:bookings).dependent(:destroy) }
    it { should have_many(:flights).through(:bookings) }
  end
end
