class Api::V1::AssetsController < Api::V1::BaseController
  before_action :set_asset, only: [:edit, :update, :destroy]

  resource_description do
    short 'Inventory asset'
    description 'Assets are things that are tracked by the help of this inventory'
  end

  def_param_group :asset do
    param :asset, Hash, required: true, action_aware: true do
      param :name, String, desc: 'External Identifier'
      param :type, String, desc: 'The asset subclass'
      param :properties, Hash, desc: 'The subclasses attributes'
    end
  end

  api :GET, '/assets'
  description 'Provide a list of all assets.'
  def index
    @assets = Asset.all
  end

  api :GET, '/assets/:id'
  param :id, String, desc: 'Internal identifier', required: true
  description 'Fetch an asset from the database by its identifier. Use the internal or external identifier.'
  def show
    if ( params[:id] =~ /^\d+$/ )
      set_asset
    else
      @asset = Asset.find_by_name!(params[:id])
    end
  end

  api :POST, '/assets'
  param_group :asset
  description 'Create a new asset.'
  def create
    @asset = Asset.new(asset_params)

    if @asset.save
      render :show, status: :created, location: @asset
    else
      render json: @asset.errors, status: :unprocessable_entity
    end
  end

  api :PUT, '/assets/:id'
  param_group :asset
  description 'Update an existing asset.'
  def update
    if @asset.update(asset_params)
      render :show, status: :ok, location: @asset
    else
      render json: @asset.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/assets/:id'
  param :id, Integer, desc: 'Internal identifier', required: true
  description 'Remove an existing asset.'
  def destroy
    @asset.destroy
      head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Asset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.require(:asset).permit(:name, :type, :properties)
    end
end
