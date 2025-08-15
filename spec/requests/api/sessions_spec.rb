RSpec.describe 'Session API', type: :request do
  include TestHelpers::RequestsApi

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
        post api_session_path, params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when session param is empty' do
      it 'returns a status code 400 without any content' do
        post api_session_path, params: { session: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when the required session params are missing' do
      it 'returns a status code 401 and correct error message' do
        post api_session_path, params: { session: random_hash }

        expect(response).to have_http_status :unauthorized
        expect(response_body(:errors)[:credentials]).to eq(['are invalid'])
      end
    end

    context 'when the required session params are invalid' do
      it 'returns a status code 401 and correct error message' do
        post api_session_path, params: { session: { email: '', password: '' } }

        expect(response).to have_http_status :unauthorized
        expect(response_body(:errors)[:credentials]).to eq(['are invalid'])
      end
    end

    context 'when all params are valid' do
      let!(:user)          { create(:user) }
      let(:returned_user)  { response_body(:session)[:user] }
      let(:returned_token) { response_body(:session)[:token] }

      it 'returns a status code 201, new token, and the user with the correct attributes' do
        post api_session_path,
             params: { session: { email: user.email, password: user.password_digest } }

        expect(response).to have_http_status :created
        expect(returned_token).not_to             be_empty
        expect(returned_user[:id]).to             eq user.id
        expect(returned_user[:email]).to          eq user.email
        expect(returned_user[:last_name]).to      eq user.last_name
        expect(returned_user[:first_name]).to     eq user.first_name
        expect(returned_user[:created_at]).to     eq stringify_time(user.created_at)
        expect(returned_user[:updated_at]).not_to eq stringify_time(user.updated_at)
      end
    end
  end

  # describe 'DELETE /api/session/:id' do
  #   let!(:existing_session) { create(:session) }

  #   context 'when :id param is invalid' do
  #     it 'returns a status code 404 without any content' do
  #       delete api_session_path(existing_session.id + 1)

  #       expect(response).to have_http_status :not_found
  #       expect(response.body).to be_empty
  #     end
  #   end

  #   context 'when :id param is valid' do
  #     it 'returns a status code 204 without any content and deletes the session' do
  #       expect { delete api_session_path(existing_session.id) }.to \
  #         change(User, :count).from(1).to(0)

  #       expect(response).to have_http_status :no_content
  #       expect(response.body).to be_empty
  #     end
  #   end
  # end
end
