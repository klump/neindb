#
# This worker extracts information about the CPU temperature
# from a report to build a Status object
#
class ReportWorker::Parser::Status::CpuTemperature < ReportWorker::Parser
  TYPES = %w(computer)

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
  end

  private
    def parse_cputemperature
      # CPU temperature
      if @report.data["sensors"]["output"] =~ /^coretemp.+?$\s+.+?:$\s+temp\d+_input:\s+([0-9.]+)$/
        @information[:temp] = $1
      else
        raise ReportWorker::Parser::InformationMissing
      end
    end
end
