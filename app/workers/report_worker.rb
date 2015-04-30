class ReportWorker
  include Sidekiq::Worker

  def perform(name, count)
  end

  private
  def analyze(report_id)
    report = Report.find(report_id)
  end
end
