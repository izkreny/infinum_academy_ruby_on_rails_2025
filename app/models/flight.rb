# == Schema Information
#
# Table name: flights
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  no_of_seats :integer
#  base_price  :integer          not null
#  departs_at  :datetime         not null
#  arrives_at  :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#
class Flight < ApplicationRecord
  belongs_to :company
  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings

  # TODO: If you are using the :scope option in your uniqueness validation, and you wish to create
  # a database constraint to prevent possible violations of the uniqueness validation, you must
  # create a unique index on both columns in your database.
  # https://guides.rubyonrails.org/active_record_validations.html#uniqueness
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :company_id } # rubocop:disable Rails/UniqueValidationWithoutIndex
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
