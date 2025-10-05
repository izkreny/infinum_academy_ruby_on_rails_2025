module Api
  class CompaniesController < ApplicationController
    before_action :find_object,    only: [:show, :update, :destroy]
    before_action :company_params, only: [:create, :update]

    # GET /api/companies
    def index
      @companies = Company.all

      if companies.empty?
        head :no_content
      else
        render_objects status: :ok
      end
    end

    # GET /api/companies/:id
    def show
      render_object status: :ok
    end

    # POST /api/companies
    def create
      @company = Company.new(company_params)

      if company.save
        render_object status: :created
      else
        render_errors_and_bad_request_status
      end
    end

    # PUT & PATCH /api/companies/:id
    def update
      if company.update(company_params)
        render_object status: :ok
      else
        render_errors_and_bad_request_status
      end
    end

    # DELETE /api/companies/:id
    def destroy
      if company.destroy
        head :no_content
      else
        render_errors_and_bad_request_status
      end
    end

    private

    attr_reader :company, :companies

    def company_params
      if params.key?(:company)
        @company_params ||= params.require(:company).permit(:name)
      else
        head :bad_request
      end
    end
  end
end
