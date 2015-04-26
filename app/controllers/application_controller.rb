class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Require authentication by default
  before_action :authenticate_user!

  # Handle some exceptions
  rescue_from User::NotAuthorized, with: :not_authorized

  # Devise stuff
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Change where the user is redirected to after logout
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def require_role_authorization(required_role)
    raise User::NotAuthorized unless current_user.role?(required_role)
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :name, :password, :password_confirmation, :current_password) }
    end

    def not_authorized
      respond_to do |format|
        format.json { render json: { errors: 'Access denied' }, status: 403 }
        format.html { redirect_to root_url, alert: 'Access denied' }
      end
    end
end
