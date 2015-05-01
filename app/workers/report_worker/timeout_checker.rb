class ReportWorker::TimeoutChecker < ReportWorker
  include Sidekiq::Worker

  #RUNNING_TIMEOUT = 1.hour
  RUNNING_TIMEOUT = 5.minutes

  #
  # Set the status of reports which are running and have been created for longer than
  # RUNNING_TIMEOUT to failure.
  #
  def perform(report_id)
    report = Report.find(report_id)

    if ( ( report.status == 'running' ) && ( report.starttime < RUNNING_TIMEOUT.ago ) )
      report.status = 'failure'
      report.data[:report_worker] = { error: "Timemout error. At #{Time.now} the report was running for longer than #{RUNNING_TIMEOUT} seconds. The limit is set in app/workers/report_worker.rb" }
      report.save
    end
  end
end

