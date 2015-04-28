class Api::V1::BaseController < ApplicationController #ActionController::Base
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
      api_error(status: 400, error: 'Parameter missing')
    end

    def not_found
      api_error(status: 404, error: 'Not found')
    end

    def api_error(status: 500, error: "")
      if error.blank?
        head status: status
      else
        render json: { error: error }, status: status
      end
    end
end
