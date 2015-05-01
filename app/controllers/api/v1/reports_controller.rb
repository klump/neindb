class Api::V1::ReportsController < Api::V1::BaseController
  before_action :set_report, only: [:show, :edit, :update]

  # GET /reports
  def index
    @reports = Report.all
  end

  # GET /reports/1
  def show
  end

  # POST /reports
  def create
    @report = Report.new(report_params)
    @report.user = current_user

    if @report.save
      # start the right worker
      start_worker

      render :show, status: :created, location: @report
    else
      render json: @report.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reports/1
  def update
    if @report.update(report_params)
      # start the right worker
      start_worker

      render :show, status: :ok, location: @report
    else
      render json: @report.errors, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:id, :asset_id, :status, :starttime, :endtime).tap do |whitelist|
        whitelist[:data] = params[:report][:data]
      end
    end

    def start_worker
      case @report.status
      when "running"
        # Running reports should have a timeout
        ReportWorker::TimeoutChecker.perform_in(ReportWorker::TimeoutChecker::RUNNING_TIMEOUT, @report.id)
      when "pass"
        ReportWorker::Parser.perform(@report.id)
      when "failure"
        ReportWorker::Parser.perform(@report.id)
      end
    end
end
