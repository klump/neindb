class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing, with: :missing_parameter
  rescue_from User::Unauthorized, with: :unauthorized
  rescue_from User::Forbidden, with: :forbidden
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Require authentication by default
  before_action :authenticate_user!

  # Devise stuff
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Change where the user is redirected to after logout
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def require_role_authorization(required_role)
    raise User::Forbidden unless current_user.role?(required_role)
  end

  def respond_with_error(status: 500, error: "")
    respond_to do |format|
      format.html do
        redirect_to root_url, alert: "Error #{status}: #{error}"
      end
      format.json do
        if error.blank?
          head status: status
        else
          render json: { error: error }, status: status
        end
      end
    end
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :name, :password, :password_confirmation, :current_password) }
    end

    def missing_parameter
      respond_with_error(status: 400, error: 'Parameter missing')
    end

    def unauthorized
      respond_with_error(status: 401, error: 'Unauthorized')
    end

    def forbidden 
      respond_with_error(status: 403, error: 'Forbidden')
    end

    def not_found
      respond_with_error(status: 404, error: 'Not found')
    end
end
