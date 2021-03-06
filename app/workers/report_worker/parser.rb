class ReportWorker::Parser
  include Sidekiq::Worker

  class ParserError < StandardError; end
  class InformationMissing < StandardError; end
  class TypeMissing < StandardError; end

  REQUIRE = []

  #
  # Allows the registering of parsers for certain asset types
  #
  @@parsers = {}
  def self.add(parser,prio)
    @@parsers[parser] = prio
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

    parsers_for(report.data["reporter"]["type"]).each do |parser|
      begin
        parser::REQUIRE.each do |requirement|
          raise InformationMissing, "The #{parser} parser requires information from the #{requirement} collector." unless report.data[requirement.to_s]
        end
        p = parser.new(report)
        p.analyze
        # refresh the report object, in case the parser made any changes to it
        report.reload
      rescue => exception
        report.update!(parser_status: 'failure')
        raise exception
      end
    end

    # Everything went well
    report.update!(parser_status: 'success')
  end

  private
    #
    # Return an array for the parsers of the right asset type sorted by their priority
    #
    def parsers_for type
      raise TypeMissing, "You need to specify a type" unless type

      parsers = @@parsers.select do |parser,prio|
        parser::TYPES.include?(type) 
      end

      parsers = parsers.sort_by do |parser,prio|
        prio
      end

      parsers.to_h.keys
    end
end
