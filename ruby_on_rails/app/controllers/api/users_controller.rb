module Api
  class UsersController < ApplicationController
    before_action :authenticate_user,       except: [:create, :index]
    before_action :user_params,             only:   [:create, :update]
    before_action :find_object, :authorize, only:   [:show, :update, :destroy]

    # GET /api/users
    def index
      # TODO: unless admin!!!
      @users = User.all

      if users.empty?
        head :no_content
      else
        render_objects status: :ok
      end
    end

    # GET /api/users/:id
    def show
      render_object status: :ok
    end

    # POST /api/users
    def create
      @user = User.new(user_params)

      if user.save
        render_object status: :created
      else
        render_errors_and_bad_request_status
      end
    end

    # PUT & PATCH /api/users/:id
    def update
      if user.update(user_params)
        render_object status: :ok
      else
        render_errors_and_bad_request_status
      end
    end

    # DELETE /api/users/:id
    def destroy
      if user.destroy
        head :no_content
      else
        render_errors_and_bad_request_status
      end
    end

    private

    attr_reader :user, :users

    def user_params
      if params.key?(:user)
        @user_params ||=
          params
          .require(:user)
          .permit(:first_name, :last_name, :email, :password_digest)
      else
        head :bad_request
      end
    end

    def authorize
      render_resource_errors_and_forbidden_status if Current.user != user
    end
  end
end
