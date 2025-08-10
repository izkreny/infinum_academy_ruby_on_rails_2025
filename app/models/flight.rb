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
class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id }
  validates :no_of_seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :base_price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :departs_at, presence: true
  validates :arrives_at, presence: true
  validate  :departure_comes_before_arrival

  def departure_comes_before_arrival
    return if departs_at.nil? || arrives_at.nil?
    return if departs_at < arrives_at

    errors.add(:departs_at, 'departure time must be before the arrival time')
    errors.add(:arrives_at, 'arrival time must be after the departure time')
  end
end
