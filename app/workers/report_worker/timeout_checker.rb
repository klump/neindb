class ReportWorker::TimeoutChecker < ReportWorker
  include Sidekiq::Worker

  #RUNNING_TIMEOUT = 1.hour
  RUNNING_TIMEOUT = 5.minutes

  #
  # Set the status of reports which are running to failure.
  # This method should most likely be called with a delay (e.g. perform_in)
  #
  def perform(report_id)
    report = Report.find(report_id)

    if ( report.status == 'parsing' )
      report.status = 'failure'
      report.data[:report_worker] = { error: "Timemout error. At #{Time.now} the report was running for longer than #{RUNNING_TIMEOUT} seconds. The limit is set in app/workers/report_worker/timeout_checker.rb" }
      report.save
    end
  end
end
