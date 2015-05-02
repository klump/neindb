class ReportWorker::Parser::TimeoutChecker < ReportWorker
  include Sidekiq::Worker

  #PARSING_TIMEOUT= 1.hour
  PARSING_TIMEOUT = 5.minutes

  #
  # Set the parser_status of reports which are currently worked on to failure.
  # This method should most likely be called with a delay (e.g. perform_in)
  #
  def perform(report_id)
    report = Report.find(report_id)

    if ( report.parser_status == 'parsing' )
      report.parser_status = 'failure'
      report.data[:report_worker] = { error: "Timemout error. At #{Time.now} the report was being parsed for longer than #{PARSING_TIMEOUT} seconds. The limit is set in app/workers/report_worker/parser/timeout_checker.rb" }
      report.save
    end
  end
end
