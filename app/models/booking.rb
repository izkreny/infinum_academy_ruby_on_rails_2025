# == Schema Information
#
# Table name: bookings
#
#  id          :bigint           not null, primary key
#  no_of_seats :integer          not null
#  seat_price  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  flight_id   :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_bookings_on_flight_id  (flight_id)
#  index_bookings_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (flight_id => flights.id)
#  fk_rails_...  (user_id => users.id)
#
class Booking < ApplicationRecord
  belongs_to :flight
  belongs_to :user

  validates :no_of_seats, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :seat_price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate  :flight_departs_in_the_future

  def flight_departs_in_the_future
    return if flight.nil?
    return if flight.departs_at.nil?
    return if flight.departs_at > DateTime.now

    errors.add(:flight, 'departure time of the flight can not be in the past')
  end
end
