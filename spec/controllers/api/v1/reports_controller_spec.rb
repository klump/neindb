require 'rails_helper'

describe Api::V1::ReportsController, type: :controller  do
  before(:each) { 
    request.headers['X-Nein-API-Version'] = 1
    request.headers['Accept'] = :json
  }

  describe '#index (GET /reports)' do
    before(:each) do
      @reports = []
      @reports << FactoryGirl.create(:report)
      @reports << FactoryGirl.create(:report_running)
      @reports << FactoryGirl.create(:report_failed)

      get :index, format: :json
    end

    it 'responds with a HTTP 200 status code' do
      expect(response).to be_success
    end

    it 'loads the information about all reports into @reports' do
      expect(assigns(:reports)).to match_array(@reports)
    end
  end

  describe '#show (GET /report/:id)' do
    context 'when the report exists' do
      before(:each) do
        @report = FactoryGirl.create(:report)

        get :show, id: @report.id, format: :json
      end

      it 'responds with a HTTP 200 status code' do
        expect(response).to be_success
      end

      it 'loads the information about a report into @report' do
        expect(assigns(:report)).to eql @report
      end
    end

    context 'when the report does not exist' do
      before(:each) do
        get :show, id: 42, format: :json
      end

      it 'responds with a HTTP 404 status code' do
        expect(response).to have_http_status(404)
      end

      it 'returns some error message' do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to have_key(:errors)
      end
    end
  end

  describe '#create (POST /reports)' do
    context 'when is successfully created' do
      before(:each) do
        @report_attributes = FactoryGirl.attributes_for :report

        post :create, { report: @report_attributes }, format: :json
      end

      it 'responds with a HTTP 201 status code' do
        expect(response).to have_http_status(201)
      end

      it 'loads the information about the new report into @report' do
        expect(assigns(:report).status).to eq @report_attributes[:status].to_s
      end
    end
    context 'when is not created' do
      before(:each) do
        @report_attributes = FactoryGirl.attributes_for :report_invalid

        post :create, { report: @report_attributes }, format: :json
      end

      it 'responds with a HTTP 422 status code' do
        expect(response).to have_http_status(422)
      end

      it 'returns error message which describe why the report could not be created' do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to have_key(:status)
        expect(json).to have_key(:starttime)
      end
    end
  end

  describe '#update (PUT /reports/:id)' do
    context 'when is successfully updated' do
      before(:each) do
        @report = FactoryGirl.create(:report_running)
        @new_report_attributes = {
          status: :pass,
          endtime: Time.now,
          data: {
            dmesg: {
              output: "Lots of text",
              error: "",
              exitcode: 0
            }
          }
        }

        put :update, { id: @report.id, report: @new_report_attributes }, format: :json
      end

      it 'responds with a HTTP 200 status code' do
        expect(response).to be_success
      end

      it 'updates the infomration about the report' do
        @saved_report = Report.find(@report.id)
        expect(@saved_report.status).to eql @new_report_attributes[:status].to_s
      end
    end
    context 'when is not updated' do
      before(:each) do
        @report = FactoryGirl.create(:report_running)
        @new_report_attributes = {
          status: :invalid,
          starttime: nil
        }

        put :update, { id: @report.id, report: @new_report_attributes }, format: :json
      end

      it 'responds with a HTTP 422 status code' do
        expect(response).to have_http_status(422)
      end

      it 'returns error message which describe why the report could not be updated' do
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to have_key(:status)
        expect(json).to have_key(:starttime)
      end

      it 'does not update the infomration about the report' do
        @saved_report = Report.find(@report.id)
        expect(@saved_report.status).to eql @report.status.to_s
      end
    end
  end
end
