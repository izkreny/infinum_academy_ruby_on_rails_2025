# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  first_name :string           not null
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  functional_index_users_on_email  (lower((email)::text)) UNIQUE
#  index_users_on_email             (email) UNIQUE
#
RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validation' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('user@email.com').for(:email) } # rubocop:disable RSpec/ImplicitExpect
    it { should_not allow_value('jeff@amazon').for(:email) } # rubocop:disable RSpec/ImplicitExpect
    it { should_not allow_value('user_email.com').for(:email) } # rubocop:disable RSpec/ImplicitExpect
    it { should_not allow_value('user@email_com').for(:email) } # rubocop:disable RSpec/ImplicitExpect
    it { is_expected.to have_db_index(:email).unique }
    it { is_expected.to have_db_index('lower((email)::text)').unique }
  end

  describe 'association' do
    it { is_expected.to have_many(:bookings).dependent(:destroy) }
    it { is_expected.to have_many(:flights).through(:bookings) }
  end
end
