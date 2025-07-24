module Api
  class BookingsController < ApplicationController
    # GET /bookings
    def index
      bookings = Booking.all

      if bookings.empty?
        render json: { errors: { bookings: '204 - No Content' } }, status: :no_content
      else
        render json: BookingSerializer.render(bookings, root: :bookings), status: :ok
      end
    end

    # GET /bookings/:id
    def show
      booking = find_booking

      if booking.nil?
        render_error_not_found('booking')
      else
        render json: BookingSerializer.render(booking, root: :booking), status: :ok
      end
    end

    # POST /bookings
    def create
      booking = Booking.new(booking_params)

      if booking.save
        render json: BookingSerializer.render(booking, root: :booking), status: :created
      else
        render_errors_bad_request(booking.errors)
      end
    end

    # PUT & PATCH /bookings/:id
    def update
      booking = find_booking

      if booking.nil?
        render_error_not_found('booking')
      elsif booking.update(booking_params)
        render json: BookingSerializer.render(booking, root: :booking), status: :ok
      else
        render_errors_bad_request(booking.errors)
      end
    end

    # DELETE /bookings/:id
    def destroy
      booking = find_booking

      if booking.nil?
        render_error_not_found('booking')
      elsif booking.destroy
        render json: { booking: '' }, status: :ok
      else
        render_errors_bad_request(booking.errors)
      end
    end

    private

    def find_booking
      Booking.where(id: params[:id]).first
    end

    def booking_params
      params.require(:booking).permit(:no_of_seats, :seat_price, :user_id, :flight_id)
    end
  end
end
