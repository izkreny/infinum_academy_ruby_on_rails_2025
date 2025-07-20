module FakeBooking
  def self.new
    Booking.new(
      no_of_seats: 1,
      seat_price: 10,
      user: FakeUser.create,
      flight: FakeFlight.create
    )
  end

  def self.create
    booking = new
    booking.save
    booking
  end
end
