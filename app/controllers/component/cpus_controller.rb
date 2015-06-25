class Component::CpusController < ApplicationController
  before_action :set_component, only: [:show, :edit, :update, :destroy]

  # GET /component/cpus
  # GET /component/cpus.json
  def index
    @components = Component::Cpu.all
  end

  # GET /component/cpus/1
  # GET /component/cpus/1.json
  def show
  end

  # DELETE /component/cpus/1
  # DELETE /component/cpus/1.json
  def destroy
    @component.destroy
    respond_to do |format|
      format.html { redirect_to components_url, notice: 'Component was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_component
      @component = Component::Cpu.find(params[:id])
    end
end
