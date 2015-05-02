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
    case report.parser_status
    when "parsing"
      raise ReportWorker::AlreadyInProgress
    when "success"
      raise ReportWorker::AlreadyDone
    when "failure"
      raise ReportWorker::AlreadyDone
    end

    report.update!(parser_status: 'parsing')

    # Start a timeout worker for the parser
    ReportWorker::Parser::TimeoutChecker.perform_in(ReportWorker::Parser::TimeoutChecker::PARSING_TIMEOUT, report.id)

    @@parsers.each do |parser|
      if parser::TYPES.include?(report.data["reporter"]["type"])
        p = parser.new(report)
        unless p.analyze
          @report.update(parser_status: 'failure')
          raise ParserError
        end
      end
    end


    # everything went well
    report.update!(parser_status: 'success')
  end
end
