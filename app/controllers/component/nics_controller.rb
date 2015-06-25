class Component::NicsController < ApplicationController
  before_action :set_component, only: [:show, :edit, :update, :destroy]

  # GET /component/nics
  # GET /component/nics.json
  def index
    @components = Component::Nic.all
  end

  # GET /component/nics/1
  # GET /component/nics/1.json
  def show
  end

  # DELETE /component/nics/1
  # DELETE /component/nics/1.json
  def destroy
    @component.destroy
    respond_to do |format|
      format.html { redirect_to component_nics_url, notice: 'Component was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component
      @component = Component::Nic.find(params[:id])
    end
end
