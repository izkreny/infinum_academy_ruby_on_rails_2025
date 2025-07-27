module Api
  class BookingsController < ApplicationController
    before_action :find_booking, only: [:show, :update, :destroy]

    # GET /api/bookings
    def index
      bookings = Booking.all

      if bookings.empty?
        head :no_content
      else
        render json: BookingSerializer.render(bookings, root: :bookings), status: :ok
      end
    end

    # GET /api/bookings/:id
    def show
      render json: BookingSerializer.render(booking, root: :booking), status: :ok
    end

    # POST /api/bookings
    def create
      booking = Booking.new(booking_params)

      if booking.save
        render json: BookingSerializer.render(booking, root: :booking), status: :created
      else
        render_errors_bad_request(booking.errors)
      end
    end

    # PUT & PATCH /api/bookings/:id
    def update
      if booking.update(booking_params)
        render json: BookingSerializer.render(booking, root: :booking), status: :ok
      else
        render_errors_bad_request(booking.errors)
      end
    end

    # DELETE /api/bookings/:id
    def destroy
      if booking.destroy
        head :no_content
      else
        render_errors_bad_request(booking.errors)
      end
    end

    private

    attr_reader :booking

    def find_booking
      @booking = Booking.where(id: params[:id]).first
      render_error_not_found(:booking) if booking.nil?
    end

    def booking_params
      # return {} unless params.key?(:booking)

      params.require(:booking).permit(:no_of_seats, :seat_price, :user_id, :flight_id)
    end
  end
end
