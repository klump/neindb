class UsersController < ApplicationController
  before_action :set_user, only: [:destroy]
  before_action except: [:show, :edit, :update] do
    |controller| controller.require_role_authorization(:admin)
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # Non admin users may only show themselves
    raise User::Forbidden unless ( current_user.admin? || current_user.id == params[:id] )
    set_user
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    # Non admin users may only edit themselves
    raise User::Forbidden unless ( current_user.admin? || current_user.id == params[:id] )
    set_user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    # Non admin users may only edit themselves
    raise User::Forbidden unless ( current_user.admin? || current_user.id == params[:id] )
    set_user

    # Generate a new auth_token if requested
    @user.generate_auth_token if user_params[:new_token] == "1"

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :username, :email, :role, :password, :password_confirmation, :new_token)
    end
end
