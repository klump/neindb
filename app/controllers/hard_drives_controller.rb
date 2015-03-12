class HardDrivesController < ApplicationController
  before_action :set_hard_drive, only: [:show, :edit, :update, :destroy]

  # GET /hard_drives
  # GET /hard_drives.json
  def index
    @hard_drives = HardDrive.all
  end

  # GET /hard_drives/1
  # GET /hard_drives/1.json
  def show
  end

  # GET /hard_drives/new
  def new
    @hard_drive = HardDrive.new
  end

  # GET /hard_drives/1/edit
  def edit
  end

  # POST /hard_drives
  # POST /hard_drives.json
  def create
    @hard_drive = HardDrive.new(hard_drive_params)

    respond_to do |format|
      if @hard_drive.save
        format.html { redirect_to @hard_drive, notice: 'Hard drive was successfully created.' }
        format.json { render :show, status: :created, location: @hard_drive }
      else
        format.html { render :new }
        format.json { render json: @hard_drive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hard_drives/1
  # PATCH/PUT /hard_drives/1.json
  def update
    respond_to do |format|
      if @hard_drive.update(hard_drive_params)
        format.html { redirect_to @hard_drive, notice: 'Hard drive was successfully updated.' }
        format.json { render :show, status: :ok, location: @hard_drive }
      else
        format.html { render :edit }
        format.json { render json: @hard_drive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hard_drives/1
  # DELETE /hard_drives/1.json
  def destroy
    @hard_drive.destroy
    respond_to do |format|
      format.html { redirect_to hard_drives_url, notice: 'Hard drive was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hard_drive
      @hard_drive = HardDrive.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hard_drive_params
      params.require(:hard_drive).permit(:serial, :model, :device_model, :firmware, :capacity_bytes, :rpm)
    end
end
