RSpec.describe 'Users API', type: :request do
  include TestHelpers::RequestsApi
  # rubocop:disable RSpec/ExampleLength

  describe 'GET /api/users' do
    context 'when user records do not exist' do
      it 'returns a status code 204 without any content' do
        get api_users_path

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end

    context 'when user records exist' do
      before { create_list(:user, 2) }

      it 'returns a status code 200 and a list of all users' do
        get api_users_path

        expect(response).to have_http_status :ok
        expect(response_body['users'].size).to eq User.count
      end
    end
  end

  describe 'GET /api/users/:id' do
    let!(:existing_users) { create_list(:user, 2) }

    context 'when :id parameter is invalid' do
      it "returns a status code 404 and an error message 'Not found!'" do
        get api_user_path(existing_users.last.id + 1)

        expect(response).to have_http_status :not_found
        expect(response_body['errors']['user']).to eq 'Not found!'
      end
    end

    context 'when :id parameter is valid' do
      it 'returns a status code 200 and a single user with the correct attributes' do
        get api_user_path(existing_users.first.id)

        expect(response).to have_http_status :ok
        expect(build(:user, response_body['user'])).to eq existing_users.first
      end
    end
  end

  describe 'POST /api/users' do
    context 'when user params are empty or do not exist' do
      it 'returns a status code 400 and all error keys' do
        post api_users_path
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'

        post api_users_path, params: {}
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'

        post api_users_path, params: { user: {} }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'
      end
    end

    context 'when user params are invalid or missing' do
      let!(:existing_user) { create(:user) }

      it 'returns a status code 400 and correct error keys' do
        post api_users_path, params: { user: { first_name: '', last_name: '', email: '' } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('first_name', 'email')

        post api_users_path, params: { user: { email: existing_user.email.swapcase } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('first_name', 'email')

        post api_users_path, params: { user: { random_word: random_word } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('first_name', 'email')
      end
    end

    context 'when all user params are valid' do
      let!(:user_count_before) { User.count }
      let!(:new_user)          { build(:user) }
      let(:user_count_after)   { User.count }

      it 'returns a status code 201 and a created user with the correct attributes' do
        post api_users_path,
             params: {
               user: {
                 first_name: new_user.first_name,
                 last_name: new_user.last_name,
                 email: new_user.email
               }
             }
        created_user = build(:user, response_body['user'])

        expect(response).to have_http_status :created
        expect(created_user.first_name).to eq new_user.first_name
        expect(created_user.last_name).to  eq new_user.last_name
        expect(created_user.email).to      eq new_user.email
        expect(user_count_after).to        eq(user_count_before + 1)
      end
    end
  end

  describe 'PUT /api/users/:id' do
    let!(:existing_users) { create_list(:user, 2) }

    context 'when :id parameter is invalid' do
      it "returns a status code 404 and an error message 'Not found!'" do
        put api_user_path(existing_users.last.id + 1),
            params: { user: { random_word: random_word } }

        expect(response).to have_http_status :not_found
        expect(response_body['errors']['user']).to eq 'Not found!'
      end
    end

    context 'when :id parameter is valid but user params are invalid' do
      it 'returns a status code 400 and correct error keys' do
        put api_user_path(existing_users.first.id),
            params: { user: { email: existing_users.last.email.swapcase } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('email')

        put api_user_path(existing_users.first.id),
            params: { user: { first_name: '', last_name: '', email: '' } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('first_name', 'email')
      end
    end

    context 'when :id parameter is valid but user param is missing or empty, ' \
            'or request params do not exist at all' do
      it 'returns a status code 400 and unmodified user' do
        put api_user_path(existing_users.first.id)
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'

        put api_user_path(existing_users.first.id), params: {}
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'

        put api_user_path(existing_users.first.id), params: { user: {} }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'
      end
    end

    context 'when :id parameter is valid but user params are missing' do
      it 'returns a status code 200 and an unmodified user' do
        put api_user_path(existing_users.first.id),
            params: { user: { random_word: random_word } }
        expect(response).to have_http_status :ok
        expect(build(:user, response_body['user'])).to eq existing_users.first
      end
    end

    context 'when all user params are valid' do
      let!(:new_user) { build(:user) }

      it 'returns a status code 200 and an updated user with the correct attributes' do
        put api_user_path(existing_users.first.id),
            params: {
              user: {
                first_name: new_user.first_name,
                last_name: new_user.last_name,
                email: new_user.email
              }
            }
        updated_user = build(:user, response_body['user'])

        expect(response).to have_http_status :ok
        expect(updated_user.first_name).to     eq new_user.first_name
        expect(updated_user.last_name).to      eq new_user.last_name
        expect(updated_user.email).to          eq new_user.email
        expect(updated_user.created_at).to     eq existing_users.first.created_at
        expect(updated_user.updated_at).not_to eq existing_users.first.updated_at
      end
    end
  end

  describe 'PATCH /api/users/:id' do
    let!(:existing_users) { create_list(:user, 2) }

    context 'when :id parameter is invalid' do
      it "returns a status code 404 and an error message 'Not found!'" do
        patch api_user_path(existing_users.last.id + 1),
              params: { user: { random_word: random_word } }

        expect(response).to have_http_status :not_found
        expect(response_body['errors']['user']).to eq 'Not found!'
      end
    end

    context 'when :id parameter is valid but user params are invalid' do
      it 'returns a status code 400 and correct error keys' do
        patch api_user_path(existing_users.first.id),
              params: { user: { email: existing_users.last.email.swapcase } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('email')

        patch api_user_path(existing_users.first.id),
              params: { user: { first_name: '', last_name: '', email: '' } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('first_name', 'email')
      end
    end

    context 'when :id parameter is valid but user param is missing or empty, ' \
            'or request params do not exist at all' do
      it 'returns a status code 400 and unmodified user' do
        patch api_user_path(existing_users.first.id)
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'

        patch api_user_path(existing_users.first.id), params: {}
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'

        patch api_user_path(existing_users.first.id), params: { user: {} }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors']['user']).to eq 'Missing parameters.'
      end
    end

    context 'when :id parameter is valid but user params are missing' do
      it 'returns a status code 200 and an unmodified user' do
        patch api_user_path(existing_users.first.id),
              params: { user: { random_word: random_word } }
        expect(response).to have_http_status :ok
        expect(build(:user, response_body['user'])).to eq existing_users.first
      end
    end

    context 'when all user params are valid' do
      let!(:new_user) { build(:user) }

      it 'returns a status code 200 and an updated user with the correct attributes' do
        patch api_user_path(existing_users.first.id),
              params: {
                user: {
                  first_name: new_user.first_name,
                  last_name: new_user.last_name,
                  email: new_user.email
                }
              }
        updated_user = build(:user, response_body['user'])

        expect(response).to have_http_status :ok
        expect(updated_user.first_name).to     eq new_user.first_name
        expect(updated_user.last_name).to      eq new_user.last_name
        expect(updated_user.email).to          eq new_user.email
        expect(updated_user.created_at).to     eq existing_users.first.created_at
        expect(updated_user.updated_at).not_to eq existing_users.first.updated_at
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let!(:existing_user)     { create(:user) }
    let!(:user_count_before) { User.count }
    let(:user_count_after)   { User.count }

    context 'when :id parameter is invalid' do
      it "returns a status code 404 and an error message 'Not found!'" do
        delete api_user_path(existing_user.id + 1)

        expect(response).to have_http_status :not_found
        expect(response_body['errors']['user']).to eq 'Not found!'
      end
    end

    context 'when :id parameter is valid' do
      it 'returns a status code 204 without any content ' \
         'and deletes the user, and all connected records' do
        delete api_user_path(existing_user.id)

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
        expect(User.where(id: existing_user.id).empty?).to be true
        expect(user_count_after).to eq(user_count_before - 1)
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength
end
