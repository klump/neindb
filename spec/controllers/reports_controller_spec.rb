require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ReportsController, type: :controller do
  login_as :user
  it_requires_authentication

  describe "GET #index" do
    it "assigns all reports as @reports" do
      report = FactoryGirl.create(:report)
      get :index, {}
      expect(assigns(:reports)).to eq([report])
    end
  end

  describe "GET #show" do
    it "assigns the requested report as @report" do
      report = FactoryGirl.create(:report)
      get :show, {:id => report.to_param}
      expect(assigns(:report)).to eq(report)
    end
  end

#  describe "DELETE #destroy" do
#    it "destroys the requested report" do
#      report = Report.create! valid_attributes
#      expect {
#        delete :destroy, {:id => report.to_param}
#      }.to change(Report, :count).by(-1)
#    end
#
#    it "redirects to the reports list" do
#      report = Report.create! valid_attributes
#      delete :destroy, {:id => report.to_param}
#      expect(response).to redirect_to(reports_url)
#    end
#  end

end