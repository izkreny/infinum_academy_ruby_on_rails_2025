RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::RequestsApi
  # rubocop:disable Style/BlockDelimiters

  describe 'GET /api/bookings' do
    context 'when booking records do not exist' do
      it 'returns a status code 204 without any content' do
        get api_bookings_path

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end

    context 'when booking records exist' do
      let!(:existing_bookings) { create_list(:booking, 2) }

      it 'returns a status code 200 and a list of all bookings' do
        get api_bookings_path

        expect(response).to have_http_status :ok
        expect(response_body(:bookings).size).to eq existing_bookings.size
      end
    end
  end

  describe 'GET /api/bookings/:id' do
    let!(:existing_booking) { create(:booking) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        get api_booking_path(existing_booking.id + 1)

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      let(:returned_booking) { response_body(:booking) }

      it 'returns a status code 200 and a single booking with the correct attributes' do
        get api_booking_path(existing_booking.id)

        expect(response).to have_http_status :ok
        expect(returned_booking[:no_of_seats]).to eq existing_booking.no_of_seats
        expect(returned_booking[:seat_price]).to  eq existing_booking.seat_price
        expect(returned_booking[:created_at]).to  eq stringify_time(existing_booking.created_at)
        expect(returned_booking[:updated_at]).to  eq stringify_time(existing_booking.updated_at)
        expect(returned_booking[:user][:id]).to   eq existing_booking.user_id
        expect(returned_booking[:flight][:id]).to eq existing_booking.flight_id
      end
    end
  end

  describe 'POST /api/bookings' do
    context 'when request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        post api_bookings_path

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when request params are empty' do
      it 'returns a status code 400 without any content' do
        post api_bookings_path, params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when booking param is empty' do
      it 'returns a status code 400 without any content' do
        post api_bookings_path, params: { booking: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when the required booking params are missing' do
      let(:required_params) { [:no_of_seats, :seat_price, :user, :flight] }

      it 'returns a status code 400 and correct error keys' do
        post api_bookings_path, params: { booking: random_hash }

        expect(response).to have_http_status :bad_request
        expect(response_body(:errors).keys).to match_array(required_params)
      end
    end

    context 'when all params are valid' do
      let!(:existing_user)   { create(:user) }
      let!(:existing_flight) { create(:flight) }
      let!(:new_booking) \
        { build(:booking, user_id: existing_user.id, flight_id: existing_flight.id) }
      let(:created_booking) { response_body(:booking) }

      it 'returns a status code 201 and a created booking with the correct attributes' do
        expect {
          post api_bookings_path, params: { booking: new_booking.attributes.compact }
        }.to change(Booking, :count).from(0).to(1)

        expect(response).to have_http_status :created
        expect(created_booking[:no_of_seats]).to eq new_booking.no_of_seats
        expect(created_booking[:seat_price]).to  eq new_booking.seat_price
        expect(created_booking[:user][:id]).to   eq new_booking.user_id
        expect(created_booking[:flight][:id]).to eq new_booking.flight_id
      end
    end
  end

  describe 'PATCH /api/bookings/:id' do
    let!(:existing_booking) { create(:booking) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        patch api_booking_path(existing_booking.id + 1),
              params: { booking: random_hash }

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        patch api_booking_path(existing_booking.id)

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but request params are empty' do
      it 'returns a status code 400 without any content' do
        patch api_booking_path(existing_booking.id), params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but booking param is empty' do
      it 'returns a status code 400 without any content' do
        patch api_booking_path(existing_booking.id), params: { booking: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but required booking params are invalid' do
      let(:required_params) { [:no_of_seats, :seat_price, :user, :flight] }

      it 'returns a status code 400 and correct error keys' do
        patch api_booking_path(existing_booking.id),
              params: {
                booking: {
                  no_of_seats: '', seat_price: '',
                  user_id: existing_booking.user_id + 1,
                  flight_id: existing_booking.flight_id + 1
                }
              }

        expect(response).to have_http_status :bad_request
        expect(response_body(:errors).keys).to match_array(required_params)
      end
    end

    context 'when :id param is valid, but the booking params are missing' do
      let(:returned_booking) { response_body(:booking) }

      it 'returns a status code 200 and an unmodified booking' do
        patch api_booking_path(existing_booking.id), params: { booking: random_hash }

        expect(response).to have_http_status :ok
        expect(returned_booking[:no_of_seats]).to eq existing_booking.no_of_seats
        expect(returned_booking[:seat_price]).to  eq existing_booking.seat_price
        expect(returned_booking[:created_at]).to  eq stringify_time(existing_booking.created_at)
        expect(returned_booking[:updated_at]).to  eq stringify_time(existing_booking.updated_at)
        expect(returned_booking[:user][:id]).to   eq existing_booking.user_id
        expect(returned_booking[:flight][:id]).to eq existing_booking.flight_id
      end
    end

    context 'when all params are valid' do
      let!(:new_user)       { create(:user) }
      let!(:new_flight)     { create(:flight) }
      let!(:new_booking)    { build(:booking, user_id: new_user.id, flight_id: new_flight.id) }
      let(:updated_booking) { response_body(:booking) }

      it 'returns a status code 200 and an updated booking with the correct attributes' do
        patch api_booking_path(existing_booking.id),
              params: { booking: new_booking.attributes.compact }

        expect(response).to have_http_status :ok
        expect(updated_booking[:no_of_seats]).to    eq new_booking.no_of_seats
        expect(updated_booking[:seat_price]).to     eq new_booking.seat_price
        expect(updated_booking[:created_at]).to     eq stringify_time(existing_booking.created_at)
        expect(updated_booking[:updated_at]).not_to eq stringify_time(existing_booking.updated_at)
        expect(updated_booking[:user][:id]).to      eq new_booking.user_id
        expect(updated_booking[:flight][:id]).to    eq new_booking.flight_id
      end
    end
  end

  describe 'DELETE /api/bookings/:id' do
    let!(:existing_booking) { create(:booking) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        delete api_booking_path(existing_booking.id + 1)

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      it 'returns a status code 204 without any content and deletes the booking' do
        expect { delete api_booking_path(existing_booking.id) }.to \
          change(Booking, :count).from(1).to(0)

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end
  end
  # rubocop:enable Style/BlockDelimiters
end
