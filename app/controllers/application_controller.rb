class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push,
  # badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

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
end
