module Api
  class CompaniesController < ApplicationController
    before_action :find_company, only: [:show, :update, :destroy]

    # GET /api/companies
    def index
      companies = Company.all

      if companies.empty?
        head :no_content
      else
        render json: CompanySerializer.render(companies, root: :companies), status: :ok
      end
    end

    # GET /api/companies/:id
    def show
      render json: CompanySerializer.render(company, root: :company), status: :ok
    end

    # POST /api/companies
    def create
      company = Company.new(company_params)

      if company.save
        render json: CompanySerializer.render(company, root: :company), status: :created
      else
        render_errors_bad_request(company.errors)
      end
    end

    # PUT & PATCH /api/companies/:id
    def update
      if company.update(company_params)
        render json: CompanySerializer.render(company, root: :company), status: :ok
      else
        render_errors_bad_request(company.errors)
      end
    end

    # DELETE /api/companies/:id
    def destroy
      if company.destroy
        head :no_content
      else
        render_errors_bad_request(company.errors)
      end
    end

    private

    attr_reader :company

    def find_company
      @company = Company.where(id: params[:id]).first
      render_error_not_found(:company) if company.nil?
    end

    def company_params
      return {} unless params.key?(:company)

      params.require(:company).permit(:name)
    end
  end
end
