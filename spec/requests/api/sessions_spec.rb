RSpec.describe 'Session API', type: :request do
  include TestHelpers::RequestsApi
  let(:user) { create(:user) }

  describe 'POST /api/session' do
    context 'when request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        post api_session_path

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when request params are empty' do
      it 'returns a status code 400 without any content' do
        post api_session_path,
             params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when session param is empty' do
      it 'returns a status code 400 without any content' do
        post api_session_path,
             params: { session: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when the required session params are missing' do
      it 'returns a status code 401 and correct error message' do
        post api_session_path,
             params: { session: random_hash }

        expect(response).to have_http_status :unauthorized
        expect(response_body(:errors)[:credentials]).to eq(['are invalid'])
      end
    end

    context 'when the required session params are invalid' do
      it 'returns a status code 401 and correct error message' do
        post api_session_path,
             params: { session: { email: '', password: '' } }

        expect(response).to have_http_status :unauthorized
        expect(response_body(:errors)[:credentials]).to eq(['are invalid'])
      end
    end

    context 'when all params are valid' do
      let(:returned_user)  { response_body(:session)[:user] }
      let(:returned_token) { response_body(:session)[:token] }

      it 'returns a status code 201, new token, and the user with the correct attributes' do # rubocop:disable RSpec/ExampleLength
        post api_session_path,
             params: { session: { email: user.email, password: user.password_digest } }

        expect(response).to have_http_status :created
        expect(returned_token).not_to             be_empty
        expect(returned_token).not_to             eq user.token
        expect(returned_user[:id]).to             eq user.id
        expect(returned_user[:email]).to          eq user.email
        expect(returned_user[:last_name]).to      eq user.last_name
        expect(returned_user[:first_name]).to     eq user.first_name
        expect(returned_user[:created_at]).to     eq stringify_time(user.created_at)
        expect(returned_user[:updated_at]).not_to eq stringify_time(user.updated_at)
      end
    end
  end

  describe 'DELETE /api/session' do
    # rubocop:disable RSpec/NestedGroups
    context 'when user tries to authenticate' do
      context 'with empty request headers' do
        it 'returns a status code 401 and the correct error message' do
          delete api_session_path

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end

      context 'with invalid "Authorization" header value' do
        it 'returns a status code 401 and the correct error message' do
          delete api_session_path,
                 headers: { Authorization: '' }

          expect(response).to have_http_status :unauthorized
          expect(response_body(:errors)[:token]).to eq(['is invalid'])
        end
      end
    end

    context 'when user is authenticated' do
      it 'returns a status code 204 without any content and deletes the session' do
        delete api_session_path,
               headers: { Authorization: user.token }

        expect(response).to       have_http_status :no_content
        expect(response.body).to  be_empty
        expect(user.token).not_to eq User.find(user.id).token
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
