class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.json
  def index
    # Order the reports decending by the date
    @reports = Report.order("created_at DESC")
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])
  end
end
