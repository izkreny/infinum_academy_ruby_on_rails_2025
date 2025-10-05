module Api
  class BookingsController < ApplicationController
    before_action :authenticate_user
    before_action :booking_params,          only: [:create, :update]
    before_action :find_object, :authorize, only: [:show, :update, :destroy]

    # GET /api/bookings
    def index
      # TODO: admin see all
      @bookings = Booking.where(user_id: Current.user.id)

      if bookings.empty?
        head :no_content
      else
        render_objects status: :ok
      end
    end

    # GET /api/bookings/:id
    def show
      render_object status: :ok
    end

    # POST /api/bookings
    def create
      @booking = Booking.new(booking_params)

      if not_authorized?
        render_resource_errors_and_forbidden_status
      elsif booking.save
        render_object status: :created
      else
        render_errors_and_bad_request_status
      end
    end

    # PUT & PATCH /api/bookings/:id
    def update
      if booking.user_id != booking_params[:user_id].to_i
        render_resource_errors_and_forbidden_status
      elsif booking.update(booking_params)
        render_object status: :ok
      else
        render_errors_and_bad_request_status
      end
    end

    # DELETE /api/bookings/:id
    def destroy
      if booking.destroy
        head :no_content
      else
        render_errors_and_bad_request_status
      end
    end

    private

    attr_reader :booking, :bookings

    def booking_params
      if params.key?(:booking)
        @booking_params ||=
          params
          .require(:booking)
          .permit(:no_of_seats, :seat_price, :user_id, :flight_id)
      else
        head :bad_request
      end
    end

    def not_authorized?
      Current.user != booking.user
    end

    def authorize
      render_resource_errors_and_forbidden_status if not_authorized?
    end
  end
end
