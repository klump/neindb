class ComponentsController < ApplicationController
  # GET /components
  # GET /components.json
  def index
    @components = Component.all
  end
end
