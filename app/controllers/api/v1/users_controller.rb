class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /users/1
  def show
    # Non admin users may only view themselves
    raise User::Forbidden unless ( current_user.admin? || current_user.id == params[:id].to_i )
    set_user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
