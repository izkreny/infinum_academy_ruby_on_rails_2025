class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push,
  # badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

  def render_errors_and_bad_request_status(errors)
    render json: { errors: errors }, status: :bad_request
  end
end
