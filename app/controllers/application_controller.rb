class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Handle exceptions
  rescue_from CanCan::AccessDenied, with: :access_denied

  # Require authentication by default
  before_action :authenticate_user!

  # Always check if the user is authorized to perform the requested action
  # Make an exeption for devise
  check_authorization unless: :devise_controller?

  # Devise stuff
  before_action :configure_permitted_parameters, if: :devise_controller?


  # Change where the user is redirected to after logout
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :name, :password, :password_confirmation, :current_password) }
    end

    def access_denied
      respond_to do |format|
        format.html { redirect_to root_url, alert: 'Access denied' }
        format.json { render json: { errors: 'Access denied' }, status: :forbidden }
      end
    end
end
