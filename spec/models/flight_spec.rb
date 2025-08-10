# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  arrives_at  :datetime         not null
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  name        :string           not null
#  no_of_seats :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
# Indexes
#
#  index_flights_on_company_id                       (company_id)
#  multicolumn_index_flights_on_name_and_company_id  (lower((name)::text), company_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#
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
    let(:backward_flight) do
      build(:flight, departs_at: 11.days.from_now, arrives_at: 10.days.from_now)
    end
    let(:regular_flight) { build(:flight) }

    context 'when departure time is after the arrival time' do
      it { expect(backward_flight.valid?).to be false }
    end

    context 'when departure time is before the arrival time' do
      it { expect(regular_flight.valid?).to be true }
    end
  end
end
