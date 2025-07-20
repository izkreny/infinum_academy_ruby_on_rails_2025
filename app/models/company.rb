class Company < ApplicationRecord
  has_many :flights, dependent: :destroy
  has_many :bookings, through: :flights
end
