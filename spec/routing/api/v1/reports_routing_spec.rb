require "rails_helper"

RSpec.describe Api::V1::ReportsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/reports").to route_to("api/v1/reports#index", :format => :json)
    end

    it "routes to #show" do
      expect(:get => "/api/reports/1").to route_to("api/v1/reports#show", :id => "1", :format => :json)
    end

    it "routes to #create" do
      expect(:post => "/api/reports").to route_to("api/v1/reports#create", :format => :json)
    end

    it "routes to #update" do
      expect(:put => "/api/reports/1").to route_to("api/v1/reports#update", :id => "1", :format => :json)
    end
  end
end
