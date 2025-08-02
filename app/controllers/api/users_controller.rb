module Api
  class UsersController < ApplicationController
    before_action :find_object, only: [:show, :update, :destroy]
    before_action :user_params, only: [:create, :update]

    # GET /api/users
    def index
      users = User.all

      if users.empty?
        head :no_content
      else
        render json: UserSerializer.render(users, root: :users), status: :ok
      end
    end

    # GET /api/users/:id
    def show
      render json: UserSerializer.render(user, root: :user), status: :ok
    end

    # POST /api/users
    def create
      user = User.new(user_params)

      if user.save
        render json: UserSerializer.render(user, root: :user), status: :created
      else
        render_errors_and_bad_request_status(user.errors)
      end
    end

    # PUT & PATCH /api/users/:id
    def update
      if user.update(user_params)
        render json: UserSerializer.render(user, root: :user), status: :ok
      else
        render_errors_and_bad_request_status(user.errors)
      end
    end

    # DELETE /api/users/:id
    def destroy
      if user.destroy
        head :no_content
      else
        render_errors_and_bad_request_status(user.errors)
      end
    end

    private

    attr_reader :user

    def user_params
      if params.key?(:user)
        @user_params ||= params.require(:user).permit(:first_name, :last_name, :email)
      else
        head :bad_request
      end
    end
  end
end
