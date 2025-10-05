# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companies_on_name  (name) UNIQUE
#
RSpec.describe Company, type: :model do
  subject { create(:company) }

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe 'association' do
    it { is_expected.to have_many(:flights).dependent(:destroy) }
    it { is_expected.to have_many(:bookings).through(:flights) }
  end
end
