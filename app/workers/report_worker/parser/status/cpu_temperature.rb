#
# This worker extracts information about the CPU temperature
# from a report to build a Status object
#
class ReportWorker::Parser::Status::CpuTemperature < ReportWorker::Parser
  TYPES = %w(computer)

  REQUIRE = [:sensors]

  THRESHOLDS = {
     warning: 80,
     critical: 90,
  }
  def initialize(report)
    @report = report
    @information = {}
  end

  def analyze
    # extract the necessary information to identify the computer
    parse_cputemperature

    @status = ::Status.find_or_initialize_by(asset: @asset, name: 'cputemp')

    # Duplicate the object for comparison
    @status_old = @status.dup

    @status.state = 'unknown'
    @status.message = "CPU temperature: #{@information[:temp]}°C"
    @status.asset = @report.asset

    temp = @information[:temp].to_i

    if ( temp < THRESHOLDS[:warning] )
      @status.state = 'ok'
    elsif ( temp < THRESHOLDS[:critical] )
      @status.state = 'warning'
    else
      @status.state = 'critical'
    end

    @status.save!

    # Compare the old and the new status
    compare(@status_old, @status)
  end

  private
    def parse_cputemperature
      # CPU temperature
      if @report.data["sensors"]["output"] =~ /^coretemp.+?$\s+.+?:$\s+temp\d+_input:\s+([0-9.]+)$/
        @information[:temp] = $1.strip
      else
        raise ReportWorker::Parser::InformationMissing, "The regular expression for the CPU temperature did not yield any matches"
      end
    end

    def compare(old, new)
      changes = ::Status.changes_between(old, new)
      # Exit if there are no changes
      return unless changes

      # Create a revision
      revision = Revision.new
      revision.data = changes
      revision.revisionable = @status
      revision.trigger = @report

      revision.save!
    end
end
