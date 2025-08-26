RSpec.describe 'Bookings API', type: :request do
  include TestHelpers::RequestsApi
  # rubocop:disable Style/BlockDelimiters
  let(:existing_user)    { create(:user) }
  let(:existing_booking) { create(:booking, user: existing_user) }

  describe 'GET /api/bookings' do
    context 'when user tries to authenticate' do
      context 'with empty request headers' do
        it 'returns a status code 401 and the correct error message' do
          get api_bookings_path

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end

      context 'with invalid "Authorization" header value' do
        it 'returns a status code 401 and the correct error message' do
          get api_bookings_path,
              headers: { Authorization: '' }

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end
    end

    context 'when user is authenticated and' do
      context 'when booking records do not exist' do
        it 'returns a status code 204 without any content' do
          get api_bookings_path,
              headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :no_content
          expect(response.body).to be_empty
        end
      end

      context 'when booking records for user exist' do
        before { create_list(:booking, 2) }

        let!(:user_bookings) { create_list(:booking, 2, user: existing_user) }

        it 'returns a status code 200 and a list of all bookings' do
          get api_bookings_path,
              headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :ok
          expect(response_body(:bookings).map { |booking| booking[:id] }).to \
            match_array(user_bookings.map(&:id))
        end
      end
    end
  end

  describe 'GET /api/bookings/:id' do
    context 'when user tries to authenticate' do
      context 'with empty request headers' do
        it 'returns a status code 401 and the correct error message' do
          get api_booking_path(existing_booking.id)

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end

      context 'with invalid "Authorization" header value' do
        it 'returns a status code 401 and the correct error message' do
          get api_booking_path(existing_booking.id),
              headers: { Authorization: '' }

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end
    end

    context 'when user is authenticated and' do
      context 'when :id param is invalid' do
        it 'returns a status code 404 without any content' do
          get api_booking_path(existing_booking.id + 1),
              headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :not_found
          expect(response.body).to be_empty
        end
      end

      context 'when :id param is for booking from another user' do
        let!(:another_booking) { create(:booking) }

        it 'returns a status code 403 and the correct error message' do
          get api_booking_path(another_booking.id),
              headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :forbidden
          expect(response_body(:errors)[:resource]).to eq(['forbidden'])
        end
      end

      context 'when :id param is valid' do
        let(:returned_booking) { response_body(:booking) }

        it 'returns a status code 200 and a single booking with the correct attributes' do
          get api_booking_path(existing_booking.id),
              headers: { Authorization: existing_user.token }

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
  end

  describe 'POST /api/bookings' do
    context 'when user tries to authenticate' do
      context 'with empty request headers' do
        it 'returns a status code 401 and the correct error message' do
          post api_bookings_path,
               params: { booking: random_hash }

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end

      context 'with invalid "Authorization" header value' do
        it 'returns a status code 401 and the correct error message' do
          post api_bookings_path,
               params: { booking: random_hash },
               headers: { Authorization: '' }

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end
    end

    context 'when user is authenticated and' do
      context 'when request params do not exist at all' do
        it 'returns a status code 400 without any content' do
          post api_bookings_path,
               headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :bad_request
          expect(response.body).to be_empty
        end
      end

      context 'when request params are empty' do
        it 'returns a status code 400 without any content' do
          post api_bookings_path,
               params: {},
               headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :bad_request
          expect(response.body).to be_empty
        end
      end

      context 'when booking param is empty' do
        it 'returns a status code 400 without any content' do
          post api_bookings_path,
               params: { booking: {} },
               headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :bad_request
          expect(response.body).to be_empty
        end
      end

      context 'when the required booking params, except the user, are invalid' do
        let(:required_params) { [:no_of_seats, :seat_price, :flight] }

        it 'returns a status code 400 and correct error keys' do # rubocop:disable RSpec/ExampleLength
          post api_bookings_path,
               params: {
                 booking: {
                   no_of_seats: 0,
                   seat_price: 0,
                   flight_id: nil,
                   user_id: existing_user.id
                 }
               },
               headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :bad_request
          expect(response_body(:errors).keys).to match_array(required_params)
        end
      end

      context 'when the required booking params are missing' do
        it 'returns a status code 403 and the correct error message' do
          post api_bookings_path,
               params: { booking: random_hash },
               headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :forbidden
          expect(response_body(:errors)[:resource]).to eq(['forbidden'])
        end
      end

      context 'when the user_id booking param is invalid' do
        it 'returns a status code 403 and the correct error message' do
          post api_bookings_path,
               params: { booking: { user_id: existing_user.id + 1 } },
               headers: { Authorization: existing_user.token }

          expect(response).to have_http_status :forbidden
          expect(response_body(:errors)[:resource]).to eq(['forbidden'])
        end
      end

      context 'when all params are valid' do
        let!(:existing_flight) { create(:flight) }
        let!(:new_booking) \
          { build(:booking, user_id: existing_user.id, flight_id: existing_flight.id) }
        let(:created_booking) { response_body(:booking) }

        it 'returns a status code 201 and a created booking with the correct attributes' do
          expect do
            post api_bookings_path,
                 params: { booking: new_booking.attributes.compact },
                 headers: { Authorization: existing_user.token }
          end.to change(Booking, :count).from(0).to(1)

          expect(response).to have_http_status :created
          expect(created_booking[:no_of_seats]).to eq new_booking.no_of_seats
          expect(created_booking[:seat_price]).to  eq new_booking.seat_price
          expect(created_booking[:user][:id]).to   eq new_booking.user_id
          expect(created_booking[:flight][:id]).to eq new_booking.flight_id
        end
      end
    end
  end

  describe 'PATCH /api/bookings/:id' do
    context 'when user tries to authenticate' do
      context 'with empty request headers' do
        it 'returns a status code 401 and the correct error message' do
          patch api_booking_path(existing_booking.id)

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end

      context 'with invalid "Authorization" header value' do
        it 'returns a status code 401 and the correct error message' do
          patch api_booking_path(existing_booking.id),
                headers: { Authorization: '' }

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end
    end

    context 'when user is authenticated and' do
      context 'when :id param is for nonexistent booking' do
        it 'returns a status code 404 without any content' do
          patch api_booking_path(existing_booking.id + 1),
                headers: { Authorization: existing_user.token },
                params: { booking: random_hash }

          expect(response).to have_http_status :not_found
          expect(response.body).to be_empty
        end
      end

      context 'when :id param is for booking from another user' do
        let!(:another_booking) { create(:booking) }

        it 'returns a status code 403 and the correct error message' do
          patch api_booking_path(another_booking.id),
                headers: { Authorization: existing_user.token },
                params: { booking: random_hash }

          expect(response).to have_http_status :forbidden
          expect(response_body(:errors)[:resource]).to eq(['forbidden'])
        end
      end

      context 'when :id param is valid and' do
        context 'when request params do not exist at all' do
          it 'returns a status code 400 without any content' do
            patch api_booking_path(existing_booking.id),
                  headers: { Authorization: existing_user.token }

            expect(response).to have_http_status :bad_request
            expect(response.body).to be_empty
          end
        end

        context 'when request params are empty' do
          it 'returns a status code 400 without any content' do
            patch api_booking_path(existing_booking.id),
                  headers: { Authorization: existing_user.token },
                  params: {}

            expect(response).to have_http_status :bad_request
            expect(response.body).to be_empty
          end
        end

        context 'when booking param is empty' do
          it 'returns a status code 400 without any content' do
            patch api_booking_path(existing_booking.id),
                  headers: { Authorization: existing_user.token },
                  params: { booking: {} }

            expect(response).to have_http_status :bad_request
            expect(response.body).to be_empty
          end
        end

        context 'when the required booking params, except the user_id, are invalid' do
          let(:required_params) { [:no_of_seats, :seat_price, :flight] }

          it 'returns a status code 400 and correct error keys' do
            patch api_booking_path(existing_booking.id),
                  headers: { Authorization: existing_user.token },
                  params: {
                    booking: {
                      no_of_seats: nil, seat_price: nil, flight_id: nil,
                      user_id: existing_booking.user_id
                    }
                  }

            expect(response).to have_http_status :bad_request
            expect(response_body(:errors).keys).to match_array(required_params)
          end
        end

        context 'when user try to change booking ownership' do
          let!(:another_user) { create(:user) }

          it 'returns a status code 403 and the correct error message' do
            patch api_booking_path(existing_booking.id),
                  headers: { Authorization: existing_user.token },
                  params: { booking: { user_id: another_user.id } }

            expect(response).to have_http_status :forbidden
            expect(response_body(:errors)[:resource]).to eq(['forbidden'])
          end
        end

        context 'when the booking params, except the user_id, are missing' do
          let(:returned_booking) { response_body(:booking) }

          it 'returns a status code 200 and an unmodified booking' do
            patch api_booking_path(existing_booking.id),
                  headers: { Authorization: existing_user.token },
                  params: { booking: { user_id: existing_booking.user_id } }

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

      context 'when all params are valid' do
        let!(:existing_flight) { create(:flight) }
        let!(:new_booking) {
          build(:booking,
                user_id: existing_user.id,
                flight_id: existing_flight.id)
        }
        let(:updated_booking) { response_body(:booking) }

        it 'returns a status code 200 and an updated booking with the correct attributes' do
          patch api_booking_path(existing_booking.id),
                headers: { Authorization: existing_user.token },
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
  end

  describe 'DELETE /api/bookings/:id' do
    context 'when user tries to authenticate' do
      context 'with empty request headers' do
        it 'returns a status code 401 and the correct error message' do
          delete api_booking_path(existing_booking.id)

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end

      context 'with invalid "Authorization" header value' do
        it 'returns a status code 401 and the correct error message' do
          delete api_booking_path(existing_booking.id),
                 headers: { Authorization: '' }

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end
    end

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        delete api_booking_path(existing_booking.id + 1),
               headers: { Authorization: existing_user.token }

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      let!(:existing_booking) { create(:booking, user: existing_user) }

      it 'returns a status code 204 without any content and deletes the booking' do
        expect do
          delete api_booking_path(existing_booking.id),
                 headers: { Authorization: existing_user.token }
        end.to change(Booking, :count).from(1).to(0)

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end
  end
  # rubocop:enable Style/BlockDelimiters
end
