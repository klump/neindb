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

    # Check if the report is already being processed or was processed (it has a parser_status)
    return if report.parser_status

    report.update!(parser_status: 'parsing')

    # Start a timeout worker for the parser
    ReportWorker::Parser::TimeoutChecker.perform_in(ReportWorker::Parser::TimeoutChecker::PARSING_TIMEOUT, report.id)

    @@parsers.each do |parser|
      if parser::TYPES.include?(report.data["reporter"]["type"])
        begin
          p = parser.new(report)
          p.analyze
        rescue => exception
          report.update!(parser_status: 'failure')
          raise exception
        end
      end
    end

    # everything went well
    report.update!(parser_status: 'success')
  end
end
