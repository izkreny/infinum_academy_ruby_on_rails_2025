module Api
  class SessionsController < ApplicationController
    before_action :session_params,    only: [:create]
    before_action :authenticate_user, only: [:destroy]

    # POST /api/session
    def create
      @user = User.find_by(email: session_params[:email])

      if user.nil?
        render_credentials_errors_and_unauthorized_status
      elsif password_invalid?
        render_credentials_errors_and_unauthorized_status
      elsif user.regenerate_token
        render json: session_data, status: :created
      else
        render_errors_and_bad_request_status
      end
    end

    # DELETE /api/session
    def destroy
      if @authenticated_user.regenerate_token
        head :no_content
      else
        render_errors_and_bad_request_status
      end
    end

    private

    attr_reader :user

    def session_params
      if params.key?(:session)
        @session_params ||=
          params
          .require(:session)
          .permit(:email, :password)
      else
        head :bad_request
      end
    end

    def password_invalid?
      user.password_digest != session_params[:password]
    end

    def session_data
      { session:
        { token: user.token,
          user: stringify_time_values(user.attributes.except('token', 'password_digest')) } }
    end
  end
end
