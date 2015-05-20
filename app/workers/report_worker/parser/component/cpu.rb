#
# This worker can use information to build a Component::Cpu
# object from a report.
#
class ReportWorker::Parser::Component::Cpu < ReportWorker::Parser
  TYPES = %w(computer)

  def initialize(report)
    @report = report
    @information = {}
  end

  def analyze
    # extract the necessary information to identify the computer
    parse_cpuinfo
    parse_cpufreq

    @cpu = ::Component::Cpu.find_or_initialize_by(name: @information[:name])

    @cpu.vendor = @information[:vendor]
    @cpu.speed_mhz = @information[:speed_mhz]
    @cpu.cores = @information[:cores]
    @cpu.threads_per_core = @information[:threads_per_core]
    @cpu.extensions = @information[:extensions]

    @cpu.save!

    # update association between component and asset (cpu and computer)
    attachment = @cpu.attached_components.find_or_initialize_by(asset: @report.asset)
    attachment.connector = "Socket #{@information[:socket]}"
    attachment.save
  end

  private
    def parse_cpuinfo
      # CPU Information
      if @report.data["cpuinfo"]["output"] =~ /^vendor_id\s+:\s+(.+?)$.+?^model\s+name\s+:\s+(.+?)$.+?^physical\s+id\s+:\s+(\d+?)$.+?^siblings\s+:\s+(\d+?)$.+?^cpu\s+cores\s+:\s+(\d+?)$.+?^flags\s+:\s+(.+?)$/m
        @information[:vendor] = $1
        @information[:name] = $2
        @information[:socket] = $3
        @information[:cores] = $5
        @information[:threads_per_core] = $4.to_i / @information[:cores].to_i
        @information[:extensions] = $6
      else
        raise ReportWorker::Parser::InformationMissing
      end
    end

    def parse_cpufreq
      # CPUfreq Information
      if @report.data["cpufreq"]["output"] =~ /^CPU\s+\d+\s+((\d+)\s+\wHz)\s+\(\s+\d+\s+%\)\s+-\s+((\d+)\s+\wHz)/m
        @information[:speed_mhz] = $4.to_i / 1000
      else
        raise ReportWorker::Parser::InformationMissing
      end
    end
end
