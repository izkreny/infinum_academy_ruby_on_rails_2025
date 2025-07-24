module Api
  class CompaniesController < ApplicationController
    # GET /companies
    def index
      companies = Company.all

      if companies.empty?
        head :no_content
      else
        render json: CompanySerializer.render(companies, root: :companies), status: :ok
      end
    end

    # GET /companies/:id
    def show
      company = find_company

      if company.nil?
        render_error_not_found('company')
      else
        render json: CompanySerializer.render(company, root: :company), status: :ok
      end
    end

    # POST /companies
    def create
      company = Company.new(company_params)

      if company.save
        render json: CompanySerializer.render(company, root: :company), status: :created
      else
        render_errors_bad_request(company.errors)
      end
    end

    # PUT & PATCH /companies/:id
    def update
      company = find_company

      if company.nil?
        render_error_not_found('company')
      elsif company.update(company_params)
        render json: CompanySerializer.render(company, root: :company), status: :ok
      else
        render_errors_bad_request(company.errors)
      end
    end

    # DELETE /companies/:id
    def destroy
      company = find_company

      if company.nil?
        render_error_not_found('company')
      elsif company.destroy
        head :no_content
      else
        render_errors_bad_request(company.errors)
      end
    end

    private

    def find_company
      Company.where(id: params[:id]).first
    end

    def company_params
      params.require(:company).permit(:name)
    end
  end
end
