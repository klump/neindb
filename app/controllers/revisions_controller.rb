class RevisionsController < ApplicationController
  before_action :set_revision, only: [:show, :edit, :update, :destroy]

  # GET /revisions
  # GET /revisions.json
  def index
    @revisions = Revision.order("updated_at DESC")
  end

  # GET /revisions/1
  # GET /revisions/1.json
  def show
  end

  # GET /revisions/new
  def new
    @revision = Revision.new
  end

  # GET /revisions/1/edit
  def edit
  end

  # POST /revisions
  # POST /revisions.json
  def create
    @revision = Revision.new(revision_params)

    respond_to do |format|
      if @revision.save
        format.html { redirect_to @revision, notice: 'Revision was successfully created.' }
        format.json { render :show, status: :created, location: @revision }
      else
        format.html { render :new }
        format.json { render json: @revision.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /revisions/1
  # PATCH/PUT /revisions/1.json
  def update
    respond_to do |format|
      if @revision.update(revision_params)
        format.html { redirect_to @revision, notice: 'Revision was successfully updated.' }
        format.json { render :show, status: :ok, location: @revision }
      else
        format.html { render :edit }
        format.json { render json: @revision.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /revisions/1
  # DELETE /revisions/1.json
  def destroy
    @revision.destroy
    respond_to do |format|
      format.html { redirect_to revisions_url, notice: 'Revision was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_revision
      @revision = Revision.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def revision_params
      params.require(:revision).permit(:old_data, :new_data)
    end
end
