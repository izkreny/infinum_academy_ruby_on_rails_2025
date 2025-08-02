class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push,
  # badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

  def render_errors_and_bad_request_status(errors)
    render json: { errors: errors }, status: :bad_request
  end

  def find_object
    model_name =
      self.class.name
          .delete_prefix('Api::')
          .delete_suffix('Controller')
          .singularize.downcase
    eval <<-RUBY, binding, __FILE__, __LINE__ + 1 # rubocop:disable Security/Eval
      @#{model_name} = #{model_name.capitalize}.where(id: params[:id]).first
      head :not_found if #{model_name}.nil?
    RUBY
  end

  # Why, o why this only does NOT work inside the #create Controller method?!?
  #   Failure/Error: eval "render json: { errors: #{model_name}.errors }, status: :bad_request"
  #   NoMethodError: undefined method 'errors' for nil
  # def render_errors_and_bad_request_status
  #   model_name =
  #     self.class.name
  #         .delete_prefix('Api::')
  #         .delete_suffix('Controller')
  #         .singularize.downcase
  #   eval <<-RUBY, binding, __FILE__, __LINE__ + 1
  #     render json: { errors: #{model_name}.errors }, status: :bad_request
  #   RUBY
  # end
end
