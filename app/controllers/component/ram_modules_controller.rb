class Component::RamModulesController < ApplicationController
  before_action :set_component, only: [:show, :edit, :update, :destroy]

  # GET /component/ram_modules
  # GET /component/ram_modules.json
  def index
    @components = Component::RamModule.all
  end

  # GET /component/ram_modules/1
  # GET /component/ram_modules/1.json
  def show
  end

  # DELETE /component/ram_modules/1
  # DELETE /component/ram_modules/1.json
  def destroy
    @component.destroy
    respond_to do |format|
      format.html { redirect_to component_ram_modules_url, notice: 'Component was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component
      @component = Component::RamModule.find(params[:id])
    end
end
