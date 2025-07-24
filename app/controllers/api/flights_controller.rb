module Api
  class FlightsController < ApplicationController
    # GET /flights
    def index
      flights = Flight.all

      if flights.empty?
        render json: { errors: { flights: '204 - No Content' } }, status: :no_content
      else
        render json: FlightSerializer.render(flights, root: :flights), status: :ok
      end
    end

    # GET /flights/:id
    def show
      flight = find_flight

      if flight.nil?
        render_error_not_found('flight')
      else
        render json: FlightSerializer.render(flight, root: :flight), status: :ok
      end
    end

    # POST /flights
    def create
      flight = Flight.new(flight_params)

      if flight.save
        render json: FlightSerializer.render(flight, root: :flight), status: :created
      else
        render_errors_bad_request(flight.errors)
      end
    end

    # PUT & PATCH /flights/:id
    def update
      flight = find_flight

      if flight.nil?
        render_error_not_found('flight')
      elsif flight.update(flight_params)
        render json: FlightSerializer.render(flight, root: :flight), status: :ok
      else
        render_errors_bad_request(flight.errors)
      end
    end

    # DELETE /flights/:id
    def destroy
      flight = find_flight

      if flight.nil?
        render_error_not_found('flight')
      elsif flight.destroy
        render json: { flight: '' }, status: :ok
      else
        render_errors_bad_request(flight.errors)
      end
    end

    private

    def find_flight
      Flight.where(id: params[:id]).first
    end

    def flight_params
      params
        .require(:flight)
        .permit(:name, :no_of_seats, :base_price, :departs_at, :arrives_at, :flight_id)
    end
  end
end
