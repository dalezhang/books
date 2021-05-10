class ApplicationController < ActionController::API
  rescue_from BooksException, with: :render_error_messages

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { message: exception.message }, status: :not_found
  end

  private

  def render_error_messages(e)
    render json: { base: [e.message] }, status: 422
  end
end
