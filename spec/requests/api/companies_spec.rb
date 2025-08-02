RSpec.describe 'Companies API', type: :request do
  include TestHelpers::RequestsApi
  # rubocop:disable Style/BlockDelimiters

  describe 'GET /api/companies' do
    context 'when company records do not exist' do
      it 'returns a status code 204 without any content' do
        get api_companies_path

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end

    context 'when company records exist' do
      let!(:existing_companies) { create_list(:company, 2) }

      it 'returns a status code 200 and a list of all companies' do
        get api_companies_path

        expect(response).to have_http_status :ok
        expect(response_body(:companies).size).to eq existing_companies.size
      end
    end
  end

  describe 'GET /api/companies/:id' do
    let!(:existing_company) { create(:company) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        get api_company_path(existing_company.id + 1)

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      it 'returns a status code 200 and a single company with the correct attributes' do
        get api_company_path(existing_company.id)

        expect(response).to have_http_status :ok
        returned_company = response_body(:company)
        expect(returned_company['name']).to       eq existing_company.name
        expect(returned_company['created_at']).to eq stringify_time(existing_company.created_at)
        expect(returned_company['updated_at']).to eq stringify_time(existing_company.updated_at)
      end
    end
  end

  describe 'POST /api/companies' do
    context 'when request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        post api_companies_path

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when request params are empty' do
      it 'returns a status code 400 without any content' do
        post api_companies_path, params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when company param is empty' do
      it 'returns a status code 400 without any content' do
        post api_companies_path, params: { company: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when the required company params are missing' do
      it 'returns a status code 400 and correct error keys' do
        post api_companies_path, params: { company: random_hash }

        expect(response).to have_http_status :bad_request
        expect(response_body(:errors).keys).to contain_exactly('name')
      end
    end

    context 'when all params are valid' do
      let!(:new_company) { build(:company) }

      it 'returns a status code 201 and a created company with the correct attributes' do
        expect {
          post api_companies_path, params: { company: { name: new_company.name } }
        }.to change(Company, :count).from(0).to(1)

        expect(response).to have_http_status :created
        expect(response_body(:company)['name']).to eq new_company.name
      end
    end
  end

  describe 'PATCH /api/companies/:id' do
    let!(:existing_company) { create(:company) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        patch api_company_path(existing_company.id + 1),
              params: { company: random_hash }

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but request params do not exist at all' do
      it 'returns a status code 400 without any content' do
        patch api_company_path(existing_company.id)

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but request params are empty' do
      it 'returns a status code 400 without any content' do
        patch api_company_path(existing_company.id), params: {}

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but company param is empty' do
      it 'returns a status code 400 without any content' do
        patch api_company_path(existing_company.id), params: { company: {} }

        expect(response).to have_http_status :bad_request
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid, but required company params are invalid' do
      it 'returns a status code 400 and correct error keys' do
        put api_company_path(existing_company.id), params: { company: { name: '' } }

        expect(response).to have_http_status :bad_request
        expect(response_body(:errors).keys).to contain_exactly('name')
      end
    end

    context 'when :id param is valid, but the company params are missing' do
      it 'returns a status code 200 and an unmodified company' do
        patch api_company_path(existing_company.id), params: { company: random_hash }

        expect(response).to have_http_status :ok
        returned_company = response_body(:company)
        expect(returned_company['name']).to       eq existing_company.name
        expect(returned_company['created_at']).to eq stringify_time(existing_company.created_at)
        expect(returned_company['updated_at']).to eq stringify_time(existing_company.updated_at)
      end
    end

    context 'when all params are valid' do
      let!(:new_company) { build(:company) }

      it 'returns a status code 200 and an updated company with the correct attributes' do
        patch api_company_path(existing_company.id), params: { company: { name: new_company.name } }

        expect(response).to have_http_status :ok
        updated_company = response_body(:company)
        expect(updated_company['name']).to           eq new_company.name
        expect(updated_company['created_at']).to     eq stringify_time(existing_company.created_at)
        expect(updated_company['updated_at']).not_to eq stringify_time(existing_company.updated_at)
      end
    end
  end

  describe 'DELETE /api/companies/:id' do
    let!(:existing_company) { create(:company) }

    context 'when :id param is invalid' do
      it 'returns a status code 404 without any content' do
        delete api_company_path(existing_company.id + 1)

        expect(response).to have_http_status :not_found
        expect(response.body).to be_empty
      end
    end

    context 'when :id param is valid' do
      it 'returns a status code 204 and deletes the company' do
        expect { delete api_company_path(existing_company.id) }.to \
          change(Company, :count).from(1).to(0)

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end
  end
  # rubocop:enable Style/BlockDelimiters
end
