RSpec.describe 'Flights API', type: :request do
  include TestHelpers::RequestsApi
  # rubocop:disable RSpec/ExampleLength, Style/BlockDelimiters

  describe 'GET /api/flights' do
    context 'when flight records do not exist' do
      it 'returns a status code 204 without any content' do
        get api_flights_path

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end

    context 'when flight records exist' do
      let!(:existing_flights) { create_list(:flight, 2) }

      it 'returns a status code 200 and a list of all flights' do
        get api_flights_path

        expect(response).to have_http_status :ok
        expect(response_body(:flights).size).to eq existing_flights.size
      end
    end
  end

  describe 'GET /api/flights/:id' do
    let!(:existing_flight) { create(:flight) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        get api_flight_path(existing_flight.id + 1)

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      let(:returned_flight) { response_body(:flight) }

      it 'returns a status code 200 and a single flight with the correct attributes' do
        get api_flight_path(existing_flight.id)

        expect(response).to have_http_status :ok
        expect(returned_flight[:name]).to         eq existing_flight.name
        expect(returned_flight[:no_of_seats]).to  eq existing_flight.no_of_seats
        expect(returned_flight[:base_price]).to   eq existing_flight.base_price
        expect(returned_flight[:departs_at]).to   eq stringify_time(existing_flight.departs_at)
        expect(returned_flight[:arrives_at]).to   eq stringify_time(existing_flight.arrives_at)
        expect(returned_flight[:created_at]).to   eq stringify_time(existing_flight.created_at)
        expect(returned_flight[:updated_at]).to   eq stringify_time(existing_flight.updated_at)
        expect(returned_flight[:company][:id]).to eq existing_flight.company_id
      end
    end
  end

  describe 'POST /api/flights' do
    context 'when request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        post api_flights_path

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when request params are empty' do
      it 'returns a status code 400 without any content' do
        post api_flights_path, params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when flight param is empty' do
      it 'returns a status code 400 without any content' do
        post api_flights_path, params: { flight: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when the required flight params are missing' do
      let(:required_params) {
        [:name, :no_of_seats, :base_price, :departs_at, :arrives_at, :company]
      }

      it 'returns a status code 400 and correct error keys' do
        post api_flights_path, params: { flight: random_hash }

        expect(response).to have_http_status :bad_request
        expect(response_body(:errors).keys).to match_array(required_params)
      end
    end

    context 'when all params are valid' do
      let!(:existing_company) { create(:company) }
      let!(:new_flight) { build(:flight, company_id: existing_company.id) }
      let(:created_flight) { response_body(:flight) }

      it 'returns a status code 201 and a created flight with the correct attributes' do
        expect {
          post api_flights_path,
               params: { flight: stringify_time_values(new_flight.attributes.compact) }
        }.to change(Flight, :count).from(0).to(1)

        expect(response).to have_http_status :created
        expect(created_flight[:name]).to         eq new_flight.name
        expect(created_flight[:no_of_seats]).to  eq new_flight.no_of_seats
        expect(created_flight[:base_price]).to   eq new_flight.base_price
        expect(created_flight[:departs_at]).to   eq stringify_time(new_flight.departs_at)
        expect(created_flight[:arrives_at]).to   eq stringify_time(new_flight.arrives_at)
        expect(created_flight[:company][:id]).to eq new_flight.company_id
      end
    end
  end

  describe 'PATCH /api/flights/:id' do
    let!(:existing_flight) { create(:flight) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        patch api_flight_path(existing_flight.id + 1), params: { flight: random_hash }

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        patch api_flight_path(existing_flight.id)

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but request params are empty' do
      it 'returns a status code 400 without any content' do
        patch api_flight_path(existing_flight.id), params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but flight param is empty' do
      it 'returns a status code 400 without any content' do
        patch api_flight_path(existing_flight.id), params: { flight: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but required flight params are invalid' do
      let(:errors_keys) {
        [:name, :no_of_seats, :base_price, :departs_at, :arrives_at, :company]
      }

      it 'returns a status code 400 and correct error keys' do
        patch api_flight_path(existing_flight.id),
              params: {
                flight: {
                  name: '', no_of_seats: '', base_price: '', departs_at: '', arrives_at: '',
                  company_id: existing_flight.id + 1
                }
              }

        expect(response).to have_http_status :bad_request
        expect(response_body(:errors).keys).to match_array(errors_keys)
      end
    end

    context 'when :id param is valid, but the flight params are missing' do
      let(:returned_flight) { response_body(:flight) }

      it 'returns a status code 200 and an unmodified flight' do
        patch api_flight_path(existing_flight.id), params: { flight: random_hash }

        expect(response).to have_http_status :ok
        expect(returned_flight[:name]).to         eq existing_flight.name
        expect(returned_flight[:no_of_seats]).to  eq existing_flight.no_of_seats
        expect(returned_flight[:base_price]).to   eq existing_flight.base_price
        expect(returned_flight[:departs_at]).to   eq stringify_time(existing_flight.departs_at)
        expect(returned_flight[:arrives_at]).to   eq stringify_time(existing_flight.arrives_at)
        expect(returned_flight[:created_at]).to   eq stringify_time(existing_flight.created_at)
        expect(returned_flight[:updated_at]).to   eq stringify_time(existing_flight.updated_at)
        expect(returned_flight[:company][:id]).to eq existing_flight.company_id
      end
    end

    context 'when all params are valid' do
      let!(:new_company) { create(:company) }
      let!(:new_flight)  { build(:flight, company_id: new_company.id) }
      let(:updated_flight) { response_body(:flight) }

      it 'returns a status code 200 and an updated flight with the correct attributes' do
        patch api_flight_path(existing_flight.id),
              params: { flight: stringify_time_values(new_flight.attributes.compact) }

        expect(response).to have_http_status :ok
        expect(updated_flight[:name]).to           eq new_flight.name
        expect(updated_flight[:no_of_seats]).to    eq new_flight.no_of_seats
        expect(updated_flight[:base_price]).to     eq new_flight.base_price
        expect(updated_flight[:departs_at]).to     eq stringify_time(new_flight.departs_at)
        expect(updated_flight[:arrives_at]).to     eq stringify_time(new_flight.arrives_at)
        expect(updated_flight[:created_at]).to     eq stringify_time(existing_flight.created_at)
        expect(updated_flight[:updated_at]).not_to eq stringify_time(existing_flight.updated_at)
        expect(updated_flight[:company][:id]).to   eq new_flight.company_id
      end
    end
  end

  describe 'DELETE /api/flights/:id' do
    let!(:existing_flight) { create(:flight) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        delete api_flight_path(existing_flight.id + 1)

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      it 'returns a status code 204 without any content and deletes the flight' do
        expect { delete api_flight_path(existing_flight.id) }.to \
          change(Flight, :count).from(1).to(0)

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength, Style/BlockDelimiters
end
