module Api
  class FlightsController < ApplicationController
    before_action :find_flight,   only: [:show, :update, :destroy]
    before_action :flight_params, only: [:create, :update]

    # GET /api/flights
    def index
      flights = Flight.all

      if flights.empty?
        head :no_content
      else
        render json: FlightSerializer.render(flights, root: :flights), status: :ok
      end
    end

    # GET /api/flights/:id
    def show
      render json: FlightSerializer.render(flight, root: :flight), status: :ok
    end

    # POST /api/flights
    def create
      flight = Flight.new(flight_params)

      if flight.save
        render json: FlightSerializer.render(flight, root: :flight), status: :created
      else
        render_errors_bad_request(flight.errors)
      end
    end

    # PUT & PATCH /api/flights/:id
    def update
      if flight.update(flight_params)
        render json: FlightSerializer.render(flight, root: :flight), status: :ok
      else
        render_errors_bad_request(flight.errors)
      end
    end

    # DELETE /api/flights/:id
    def destroy
      if flight.destroy
        head :no_content
      else
        render_errors_bad_request(flight.errors)
      end
    end

    private

    attr_reader :flight

    def find_flight
      @flight = Flight.where(id: params[:id]).first
      render_errors_not_found(:flight) if flight.nil?
    end

    def flight_params
      if params.key?(:flight)
        @flight_params ||=
          params
          .require(:flight)
          .permit(:name, :no_of_seats, :base_price, :departs_at, :arrives_at, :company_id)
      else
        render_errors_bad_request(:flight)
      end
    end
  end
end
