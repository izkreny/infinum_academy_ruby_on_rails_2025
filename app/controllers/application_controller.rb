class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push,
  # badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

  def render_errors_not_found(object)
    render json: { errors: { object => 'Not found!' } }, status: :not_found
  end

  def render_errors_bad_request(object)
    if object.is_a?(Symbol)
      render json: { errors: { object => 'Missing parameters.' } }, status: :bad_request
    else
      render json: { errors: object }, status: :bad_request
    end
  end
end
