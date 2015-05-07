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
    parse_dmidecode
    parse_cputemperature

    @status = ::Status.new
    @status.name = 'cputemp'
    @status.state = 'unknown'
    @status.message = "CPU temperature: #{@information[:temp]}°C"
    @status.asset = ::Asset::Computer.find_by!(name: @information[:name])

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
    def parse_dmidecode
      # System Information
      if @report.data["dmidecode"]["output"] =~ /^System Information$\s+Manufacturer: (.+?)$\s+Product Name: (.+?)$\s+Version: (.*?)$\s+Serial Number: (.+?)$/m
        @information[:product_name] = $2
        @information[:name] = $4
      else
        raise ReportWorker::Parser::InformationMissing
      end
    end

    def parse_cputemperature
      # CPU temperature
      if @report.data["sensors"]["output"] =~ /^coretemp.+?$\s+.+?:$\s+temp\d+_input:\s+([0-9.]+)$/
        @information[:temp] = $1
      else
        raise ReportWorker::Parser::InformationMissing
      end
    end
end
