class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push,
  # badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

  def authenticate_user
    auth_token = request.headers['Authorization']

    if auth_token.nil?
      render_token_errors_and_unauthorized_status
    else
      # When to use ActiveSupport::SecurityUtils.secure_compare() instead?
      # TODO: class Current < ActiveSupport::CurrentAttributes; attribute :user; end
      @authenticated_user = User.find_by(token: auth_token)
      render_token_errors_and_unauthorized_status if @authenticated_user.nil?
    end
  end

  def model_name
    @model_name ||=
      self.class.name
          .delete_prefix('Api::')
          .delete_suffix('Controller')
          .singularize.downcase
  end

  # Why #find_by and not #find? To avoid raising ActiveRecord::RecordNotFound exeption
  def find_object
    eval <<-RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
      @#{model_name} = #{model_name.capitalize}.find_by(id: params[:id])
      head :not_found if #{model_name}.nil?
    RUBY
  end

  def render_object(status:)
    eval <<-RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
      render json:    #{model_name.capitalize}Serializer.render(#{model_name},
               root: :#{model_name}),
             status: :#{status}
    RUBY
  end

  def render_objects(status:)
    eval <<-RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
      render json:    #{model_name.capitalize}Serializer.render(#{model_name.pluralize},
               root: :#{model_name.pluralize}),
             status: :#{status}
    RUBY
  end

  def render_errors_and_bad_request_status
    eval <<-RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
      render json: { errors: #{model_name}.errors }, status: :bad_request
    RUBY
  end

  def render_credentials_errors_and_unauthorized_status
    render json: { errors: { credentials: ['are invalid'] } }, status: :unauthorized
  end

  def render_token_errors_and_unauthorized_status
    render json: { errors: { token: ['is invalid'] } }, status: :unauthorized
  end

  def render_resource_errors_and_forbidden_status
    render json: { errors: { resource: ['forbidden'] } }, status: :forbidden
  end

  DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S.%9N %z'
  def stringify_time_values(hash)
    hash.deep_transform_values do |value|
      value.respond_to?(:strftime) ? value.strftime(DATETIME_FORMAT) : value
    end
  end
end
