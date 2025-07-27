RSpec.describe 'Companies API', type: :request do
  include TestHelpers::RequestsApi

  describe 'GET /api/companies' do
    context 'when company records do not exist' do
      it 'returns a status code 204 without any content' do
        get api_companies_path

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
      end
    end

    context 'when company records exist' do
      before { create_list(:company, 2) }

      it 'returns a status code 200 and a list of all companies' do
        get api_companies_path

        expect(response).to have_http_status :ok
        expect(response_body['companies'].size).to eq Company.count
      end
    end
  end

  describe 'GET /api/companies/:id' do
    let!(:existing_companies) { create_list(:company, 2) }

    context 'when :id parameter is invalid' do
      it "returns a status code 404 and an error message 'Not Found'" do
        get api_company_path(existing_companies.last.id + 1)

        expect(response).to have_http_status :not_found
        expect(response_body['errors']['company']).to eq 'Not Found'
      end
    end

    context 'when :id parameter is valid' do
      it 'returns a status code 200 and a single company with the correct attributes' do
        get api_company_path(existing_companies.first.id)

        expect(response).to have_http_status :ok
        expect(build(:company, response_body['company'])).to eq existing_companies.first
      end
    end
  end

  describe 'POST /api/companies' do
    context 'when company params are empty or do not exist' do
      it 'returns a status code 400 and all error keys' do
        post api_companies_path
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')

        post api_companies_path, params: {}
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')

        post api_companies_path, params: { company: {} }
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')
      end
    end

    context 'when company params are invalid or missing' do
      let!(:existing_company) { create(:company) }

      it 'returns a status code 400 and correct error keys' do
        post api_companies_path, params: { company: { name: '' } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('name')

        post api_companies_path, params: { company: { name: existing_company.name.swapcase } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('name')

        post api_companies_path, params: { company: { random_word: random_word } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('name')
      end
    end

    context 'when all company params are valid' do
      let!(:company_count_before) { Company.count }
      let!(:new_company)          { build(:company) }
      let(:company_count_after)   { Company.count }

      it 'returns a status code 201 and a created company with the correct attributes' do
        post api_companies_path, params: { company: { name: new_company.name } }

        expect(response).to have_http_status :created
        expect(response_body['company']['name']).to eq new_company.name
        expect(company_count_after).to eq(company_count_before + 1)
      end
    end
  end

  describe 'PUT /api/companies/:id' do
    let!(:existing_companies) { create_list(:company, 2) }

    context 'when :id parameter is invalid' do
      it "returns a status code 404 and an error message 'Not Found'" do
        put api_company_path(existing_companies.last.id + 1),
            params: { company: { random_word: random_word } }

        expect(response).to have_http_status :not_found
        expect(response_body['errors']['company']).to eq 'Not Found'
      end
    end

    context 'when :id parameter is valid but company params are invalid' do
      it 'returns a status code 400 and correct error keys' do
        put api_company_path(existing_companies.first.id),
            params: { company: { name: existing_companies.last.name.swapcase } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('name')

        put api_company_path(existing_companies.first.id), params: { company: { name: '' } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('name')
      end
    end

    context 'when :id parameter is valid but company param is missing or empty, ' \
            'or request params do not exist at all' do
      it 'returns a status code 200 and unmodified company' do
        put api_company_path(existing_companies.first.id)
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')

        put api_company_path(existing_companies.first.id), params: {}
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')

        put api_company_path(existing_companies.first.id), params: { company: {} }
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')
      end
    end

    context 'when :id parameter is valid but company params are missing' do
      it 'returns a status code 200 and an unmodified company' do
        put api_company_path(existing_companies.first.id),
            params: { company: { random_word: random_word } }
        expect(response).to have_http_status :ok
        expect(build(:company, response_body['company'])).to eq existing_companies.first
      end
    end

    context 'when all company params are valid' do
      let!(:new_company) { build(:company) }

      it 'returns a status code 200 and an updated company with the correct attributes' do
        put api_company_path(existing_companies.first.id),
            params: { company: { name: new_company.name } }
        updated_company = build(:company, response_body['company'])

        expect(response).to have_http_status :ok
        expect(updated_company.name).to           eq new_company.name
        expect(updated_company.created_at).to     eq existing_companies.first.created_at
        expect(updated_company.updated_at).not_to eq existing_companies.first.updated_at
      end
    end
  end

  describe 'PATCH /api/companies/:id' do
    let!(:existing_companies) { create_list(:company, 2) }

    context 'when :id parameter is invalid' do
      it "returns a status code 404 and an error message 'Not Found'" do
        patch api_company_path(existing_companies.last.id + 1),
              params: { company: { random_word: random_word } }

        expect(response).to have_http_status :not_found
        expect(response_body['errors']['company']).to eq 'Not Found'
      end
    end

    context 'when :id parameter is valid but company param is missing or empty, ' \
            'or request params do not exist at all' do
      it 'returns a status code 200 and unmodified company' do
        patch api_company_path(existing_companies.first.id)
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')

        patch api_company_path(existing_companies.first.id), params: {}
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')

        patch api_company_path(existing_companies.first.id), params: { company: {} }
        expect(response).to have_http_status :bad_request
        # expect(response_body['errors'].keys).to contain_exactly('name')
      end
    end

    context 'when :id parameter is valid but company params are missing' do
      it 'returns a status code 200 and an unmodified company' do
        patch api_company_path(existing_companies.first.id),
              params: { company: { random_word: random_word } }
        expect(response).to have_http_status :ok
        expect(build(:company, response_body['company'])).to eq existing_companies.first
      end
    end

    context 'when :id parameter is valid but company params are invalid' do
      it 'returns a status code 400 and correct error keys' do
        patch api_company_path(existing_companies.first.id),
              params: { company: { name: existing_companies.last.name.swapcase } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('name')

        put api_company_path(existing_companies.first.id), params: { company: { name: '' } }
        expect(response).to have_http_status :bad_request
        expect(response_body['errors'].keys).to contain_exactly('name')
      end
    end

    context 'when all company params are valid' do
      let!(:new_company) { build(:company) }

      it 'returns a status code 200 and an updated company with the correct attributes' do
        patch api_company_path(existing_companies.first.id),
              params: { company: { name: new_company.name } }
        updated_company = build(:company, response_body['company'])

        expect(response).to have_http_status :ok
        expect(updated_company.name).to           eq new_company.name
        expect(updated_company.created_at).to     eq existing_companies.first.created_at
        expect(updated_company.updated_at).not_to eq existing_companies.first.updated_at
      end
    end
  end

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe 'DELETE /api/companies/:id' do
    let!(:existing_company)     { create(:company) }
    let!(:existing_flight)      { create(:flight, company: existing_company) }
    let!(:existing_user)        { create(:user) }
    let!(:existing_booking)     { create(:booking, flight: existing_flight, user: existing_user) }
    let!(:company_count_before) { Company.count }
    let!(:flight_count_before)  { Flight.count }
    let!(:booking_count_before) { Booking.count }
    let(:company_count_after)   { Company.count }
    let(:flight_count_after)    { Flight.count }
    let(:booking_count_after)   { Booking.count }

    context 'when :id parameter is invalid' do
      it "returns a status code 404 and an error message 'Not Found'" do
        delete api_company_path(existing_company.id + 1)

        expect(response).to have_http_status :not_found
        expect(response_body['errors']['company']).to eq 'Not Found'
      end
    end

    context 'when :id parameter is valid' do
      it 'returns a status code 204 without any content ' \
         'and deletes the company, and all connected records' do
        delete api_company_path(existing_company.id)

        expect(response).to have_http_status :no_content
        expect(response.body).to be_empty
        expect(Company.where(id: existing_company.id).empty?).to be true
        expect(Booking.where(id: existing_booking.id).empty?).to be true
        expect(Flight.where(id:  existing_flight.id).empty?).to  be true
        expect(User.where(id:    existing_user.id).empty?).to    be false
        expect(company_count_after).to eq(company_count_before - 1)
        expect(booking_count_after).to eq(booking_count_before - 1)
        expect(flight_count_after).to  eq(flight_count_before  - 1)
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end
