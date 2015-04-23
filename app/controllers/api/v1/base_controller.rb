class Api::V1::BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::ParameterMissing, with: :missing_parameter

  before_action :destroy_session

  protected
    def destroy_session
      request.session_options[:skip] = true
    end

    def missing_parameter
      api_error(status: 400, errors: 'Parameter missing')
    end

    def not_found
      api_error(status: 404, errors: 'Not found')
    end

    def api_error(status: 500, errors: [])
      unless Rails.env.production?
        puts errors.full_messages if errors.respond_to? :full_messages
      end

      head status: status and return if errors.empty?
      
      render json: { errors: errors }, status: status
    end
end
