module Authenticable
  # Devise methods overwrites
  def authenticate_with_token
#    render json: { error: "Not Authorized" }, status :unauthorized unless current_user
  end
end
