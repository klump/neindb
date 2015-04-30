class ReportWorker
  include Sidekiq::Worker

  class AlreadyInProgress < StandardError; end
  class AlreadyDone < StandardError; end

  RUNNING_TIMEOUT = 1.hour

  @@collectors = {}
  def self.register( collector, worker )
    @@collectors[collector] = [] if @@collectors[collector].nil?

    @@collectors[collector] << worker
    @@collectors[collector].uniq!
  end

  #
  # This function acts as a dispatcher for the more specific report parsers which then
  # attempt to extract information from a report, create and update components, assets,
  # statuses and revisions.
  #
  def analyze(report_id)
    report = Report.find(report_id)

    # Check if the report is already being processed/ was processed
    case report.worker_status
    when "parsing"
      raise AlreadyInProgress
    when "success"
      raise AlreadyDone
    when "failure"
      raise AlreadyDone
    end

    report.worker_status = 'parsing'
    report.save

    # Start the real processing
    report.data.each do |collectorname,hash|
      @@collectors[collectorname].each do |collector|
        collector.analyze(hash)
      end
    end

    # everything went well
    report.worker_status = 'success'
    report.save
  end

  #
  # Set the status of reports which are running and have been created for longer than
  # RUNNING_TIMEOUT to failure.
  #
  def check_for_timeout_failure(report_id)
    report = Report.find(report_id)

    if ( ( report.status == 'running' ) && ( report.starttime < RUNNING_TIMEOUT.ago ) )
      report.status = 'failure'
      report.data[:report_worker] = { error: "Timemout error. At #{Time.now} the report was running for longer than #{RUNNING_TIMEOUT} seconds. The limit is set in app/workers/report_worker.rb" }
      report.save
    end
  end
end
