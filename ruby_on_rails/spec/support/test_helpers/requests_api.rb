module TestHelpers
  module RequestsApi
    DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S.%9N %z'

    def response_body(key = nil)
      return JSON.parse(response.body).deep_symbolize_keys if key.nil?

      JSON.parse(response.body).deep_symbolize_keys[key]
    end

    def random_hash
      random_string = ('a'..'z').to_a.shuffle.slice(1..5).join
      key           = 'random_key_'   << random_string
      value         = 'random_value_' << random_string
      { key => value }
    end

    def stringify_time(time)
      time.respond_to?(:strftime) ? time.strftime(DATETIME_FORMAT) : time
    end

    def stringify_time_values(hash)
      hash.deep_transform_values do |value|
        value.respond_to?(:strftime) ? value.strftime(DATETIME_FORMAT) : value
      end
    end

    # Add shared examples for authentication via Claude AI BS -- NOT WORKING!!!
    RSpec.shared_examples 'authenticable endpoint' do |method, path_proc|
      context 'when user tries to authenticate' do
        context 'with empty request headers' do
          it 'returns a status code 401 and the correct error message' do
            send(method, path_proc.call)

            expect(response).to have_http_status :unauthorized
            expect(response_body(:errors)[:token]).to eq(['is invalid'])
          end
        end

        context 'with invalid "Authorization" header value' do
          it 'returns a status code 401 and the correct error message' do
            send(method, path_proc.call, headers: { Authorization: '' })

            expect(response).to have_http_status :unauthorized
            expect(response_body(:errors)[:token]).to eq(['is invalid'])
          end
        end
      end
    end

    # describe 'PATCH /api/users/:id' do
    #   let!(:existing_user) { create(:user) }

    #   it_behaves_like 'authenticable endpoint', :patch, -> { api_user_path(existing_user.id) }

    #   # ... rest of the specs
    # end
  end
end
