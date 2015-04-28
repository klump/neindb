class Api::V1::BaseController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :destroy_session

  # Ignore devise stuff and use token authentication instead
  skip_before_action :authenticate_user!
  before_action :authenticate_with_token

  def index
  end

  protected
    def destroy_session
      request.session_options[:skip] = true
    end

    def authenticate_with_token
      authorization_header = request.headers['Authorization']

      # Safe to abort here if no header is present
      raise User::Unauthorized unless authorization_header

      login, auth_token = authorization_header.split('+', 2)  
      user = User.find_for_database_authentication(login: login)
      
      # compare the users token to the auth_token provided
      if user && Devise.secure_compare(user.auth_token, auth_token)
        sign_in user, store: false
      else
        raise User::Unauthorized
      end
    end
end
