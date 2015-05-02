class ReportWorker::Parser
  include Sidekiq::Worker

  class ParserError < StandardError; end
  class InformationMissing < StandardError; end

  #
  # Allows the registering of parsers for certain asset types
  #
  @@parsers = []
  def self.add(parser)
    @@parsers << parser
    @@parsers.uniq!
  end

  #
  # This function acts as a dispatcher for the more specific report parsers which then
  # attempt to extract information from a report, create and update components, assets,
  # statuses and revisions.
  #
  def perform(report_id)
    report = Report.find(report_id)

    # Check if the report is already being processed/ was processed
    case report.worker_status
    when "parsing"
      raise ReportWorker::AlreadyInProgress
    when "success"
      raise ReportWorker::AlreadyDone
    when "failure"
      raise ReportWorker::AlreadyDone
    end

    report.worker_status = 'parsing'
    report.save

    @@parsers.each do |parser|
      if parser::TYPES.include?(report.data["reporter"]["type"])
        begin
          p = parser.new(report)
          p.analyze
        rescue ParseError
        end
      end
    end

    # everything went well
    report.worker_status = 'success'
    report.save
  end
end
