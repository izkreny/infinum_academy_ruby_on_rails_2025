module Api
  class UsersController < ApplicationController
    # GET /users
    def index
      users = User.all

      if users.empty?
        head :no_content
      else
        render json: UserSerializer.render(users, root: :users), status: :ok
      end
    end

    # GET /users/:id
    def show
      user = find_user

      if user.nil?
        render_error_not_found('user')
      else
        render json: UserSerializer.render(user, root: :user), status: :ok
      end
    end

    # POST /users
    def create
      user = User.new(user_params)

      if user.save
        render json: UserSerializer.render(user, root: :user), status: :created
      else
        render_errors_bad_request(user.errors)
      end
    end

    # PUT & PATCH /users/:id
    def update
      user = find_user

      if user.nil?
        render_error_not_found('user')
      elsif user.update(user_params)
        render json: UserSerializer.render(user, root: :user), status: :ok
      else
        render_errors_bad_request(user.errors)
      end
    end

    # DELETE /users/:id
    def destroy
      user = find_user

      if user.nil?
        render_error_not_found('user')
      elsif user.destroy
        head :no_content
      else
        render_errors_bad_request(user.errors)
      end
    end

    private

    def find_user
      User.where(id: params[:id]).first
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
  end
end
