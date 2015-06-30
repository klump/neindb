#
# This worker can use information to build a Component::Nic
# object from a report.
#
class ReportWorker::Parser::Component::Nic < ReportWorker::Parser
  TYPES = %w(computer)

  REQUIRE = [:lshw]

  def initialize(report)
    @report = report
    @nics = {}
  end

  def analyze
    # extract the necessary information to identify the computer
    parse_lshw

    @nics.each do |nic_connector,information|
      # Try to find an existing NIC with on of the IP addresses, if it does not exist create a new one
      nic = ::Component::Nic.find_by_mac_address(information[:mac_addresses].first) || ::Component::Nic.new

      nic.name = information[:name]
      nic.vendor = information[:vendor]
      nic.speed_mbits = information[:speed_mbits]
      nic.ports = information[:ports] 
      nic.mac_addresses = information[:mac_addresses]
      nic.capabilities = information[:capabilities]

      nic.save!

      # update association between component and asset (cpu and computer)
      attachment = nic.attached_components.find_or_initialize_by(asset: @report.asset)
      attachment.connector = nic_connector 
      attachment.save!
    end

    return true
  end

  private
    def parse_lshw
      # lshw
      @report.data["lshw"]["output"].scan(/-network(:\d+)?$\s+.+?$\s+product:\s+(.+?)$\s+vendor:\s+(.+?)$.+?^\s+bus info:\s+(.+?)$.+?^\s+serial:\s+(.+?)$.+?^\s+capacity:\s+(.+?)$.+?^\s+capabilities:\s+(.+?)$/m).each do |m|
        m.map! { |e| e.strip unless e.nil? }
        connector = m[3]
        @nics[connector] ||= {
          ports: 0,
          mac_addresses: [],
        }
        @nics[connector][:ports] += 1
        @nics[connector][:name] = m[1]
        @nics[connector][:vendor] = m[2]
        @nics[connector][:mac_addresses] << m[4]
        speed = m[5]
        @nics[connector][:capabilities] = m[6].split(/\s+/)

        @nics[connector][:speed_mbits] = case speed
        when /^(\d+)Gbit\/s$/
          speed.to_f * 1000
        when /^(\d+)Mbit\/s$/
          speed.to_f
        when /^(\d+)Kbit\/s$/
          speed.to_f / 1000
        else
          0
        end
    end
  end
end
