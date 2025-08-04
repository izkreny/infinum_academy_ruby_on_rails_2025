RSpec.describe 'Users API', type: :request do
  include TestHelpers::RequestsApi

  describe 'GET /api/users' do
    context 'when user records do not exist' do
      it 'returns a status code 204 without any content' do
        get api_users_path

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end

    context 'when user records exist' do
      let!(:existing_users) { create_list(:user, 2) }

      it 'returns a status code 200 and a list of all users' do
        get api_users_path

        expect(response).to have_http_status :ok
        expect(response_body(:users).size).to eq existing_users.count
      end
    end
  end

  describe 'GET /api/users/:id' do
    let!(:existing_user) { create(:user) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        get api_user_path(existing_user.id + 1)

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      let(:returned_user) { response_body(:user) }

      it 'returns a status code 200 and a single user with the correct attributes' do
        get api_user_path(existing_user.id)

        expect(response).to have_http_status :ok
        expect(returned_user[:first_name]).to eq existing_user.first_name
        expect(returned_user[:last_name]).to  eq existing_user.last_name
        expect(returned_user[:email]).to      eq existing_user.email
        expect(returned_user[:created_at]).to eq stringify_time(existing_user.created_at)
        expect(returned_user[:updated_at]).to eq stringify_time(existing_user.updated_at)
      end
    end
  end

  describe 'POST /api/users' do
    context 'when request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        post api_users_path

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when request params are empty' do
      it 'returns a status code 400 without any content' do
        post api_users_path, params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when user param is empty' do
      it 'returns a status code 400 without any content' do
        post api_users_path, params: { user: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when the required user params are missing' do
      let(:required_params) { [:first_name, :email] }

      it 'returns a status code 400 and correct error keys' do
        post api_users_path, params: { user: random_hash }

        expect(response).to have_http_status :bad_request
        expect(response_body(:errors).keys).to match_array(required_params)
      end
    end

    context 'when all params are valid' do
      let!(:new_user)    { build(:user) }
      let(:created_user) { response_body(:user) }

      it 'returns a status code 201 and a created user with the correct attributes' do
        expect { post api_users_path, params: { user: new_user.attributes.compact } }.to \
          change(User, :count).from(0).to(1)

        expect(response).to have_http_status :created
        expect(created_user[:first_name]).to eq new_user.first_name
        expect(created_user[:last_name]).to  eq new_user.last_name
        expect(created_user[:email]).to      eq new_user.email
      end
    end
  end

  describe 'PATCH /api/users/:id' do
    let!(:existing_user) { create(:user) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        patch api_user_path(existing_user.id + 1),
              params: { user: random_hash }

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        patch api_user_path(existing_user.id)

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but request params are empty' do
      it 'returns a status code 400 without any content' do
        patch api_user_path(existing_user.id), params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but user param is empty' do
      it 'returns a status code 400 without any content' do
        patch api_user_path(existing_user.id), params: { user: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but required user params are invalid' do
      let(:errors_keys) { [:first_name, :email] }

      it 'returns a status code 400 and correct error keys' do
        patch api_user_path(existing_user.id),
              params: { user: { first_name: '', last_name: '', email: '' } }

        expect(response).to have_http_status :bad_request
        expect(response_body(:errors).keys).to match_array(errors_keys)
      end
    end

    context 'when :id param is valid, but the user params are missing' do
      let(:returned_user) { response_body(:user) }

      it 'returns a status code 200 and an unmodified user' do
        patch api_user_path(existing_user.id), params: { user: random_hash }

        expect(response).to have_http_status :ok
        expect(returned_user[:first_name]).to eq existing_user.first_name
        expect(returned_user[:last_name]).to  eq existing_user.last_name
        expect(returned_user[:email]).to      eq existing_user.email
        expect(returned_user[:created_at]).to eq stringify_time(existing_user.created_at)
        expect(returned_user[:updated_at]).to eq stringify_time(existing_user.updated_at)
      end
    end

    context 'when all params are valid' do
      let!(:new_user)    { build(:user) }
      let(:updated_user) { response_body(:user) }

      it 'returns a status code 200 and an updated user with the correct attributes' do
        patch api_user_path(existing_user.id),
              params: { user: new_user.attributes.compact }

        expect(response).to have_http_status :ok
        expect(updated_user[:first_name]).to     eq new_user.first_name
        expect(updated_user[:last_name]).to      eq new_user.last_name
        expect(updated_user[:email]).to          eq new_user.email
        expect(updated_user[:created_at]).to     eq stringify_time(existing_user.created_at)
        expect(updated_user[:updated_at]).not_to eq stringify_time(existing_user.updated_at)
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let!(:existing_user) { create(:user) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        delete api_user_path(existing_user.id + 1)

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      it 'returns a status code 204 without any content and deletes the user' do
        expect { delete api_user_path(existing_user.id) }.to \
          change(User, :count).from(1).to(0)

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end
  end
end
