class Api::V1::BaseController < ApplicationController #ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :destroy_session

  protected
    def destroy_session
      request.session_options[:skip] = true
    end
end
