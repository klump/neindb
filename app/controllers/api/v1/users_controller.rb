class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /assets/1
  # GET /assets/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
end
