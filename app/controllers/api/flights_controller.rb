module Api
  class FlightsController < ApplicationController
    before_action :find_object,   only: [:show, :update, :destroy]
    before_action :flight_params, only: [:create, :update]

    # GET /api/flights
    def index
      @flights = Flight.all

      if flights.empty?
        head :no_content
      else
        render_objects status: :ok
      end
    end

    # GET /api/flights/:id
    def show
      render_object status: :ok
    end

    # POST /api/flights
    def create
      @flight = Flight.new(flight_params)

      if flight.save
        render_object status: :created
      else
        render_errors_and_bad_request_status
      end
    end

    # PUT & PATCH /api/flights/:id
    def update
      if flight.update(flight_params)
        render_object status: :ok
      else
        render_errors_and_bad_request_status
      end
    end

    # DELETE /api/flights/:id
    def destroy
      if flight.destroy
        head :no_content
      else
        render_errors_and_bad_request_status
      end
    end

    private

    attr_reader :flight, :flights

    def flight_params
      if params.key?(:flight)
        @flight_params ||=
          params
          .require(:flight)
          .permit(:name, :no_of_seats, :base_price, :departs_at, :arrives_at, :company_id)
      else
        head :bad_request
      end
    end
  end
end
