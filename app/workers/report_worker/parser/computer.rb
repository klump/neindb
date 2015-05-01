#
# This worker can use information to build a Asset::Computer
# object from a report.
#
class ReportWorker::Parser::Computer < ReportWorker::Parser
  def self.analyze(report)
    @report = report
    @report.worker_status = 'parsing'
    @report.save

    @information = {}
  
    # extract the necessary information to identify the computer
    parse_dmidecode
    parse_lshw
    parse_location

    @computer = Asset::Computer.find_or_create_by(name: @information[:name])
    @computer.product_name = @information[:product_name]
    @computer.bios_vendor = @information[:bios_vendor]
    @computer.bios_version = @information[:bios_version]
    @computer.pci_slots = @information[:pci_slots]
    @computer.pcie_slots = @information[:pcie_slots]
    @computer.dimm_slots = @information[:dimm_slots]
    @computer.location = @information[:location]

    if @computer.save
      @report.worker_status = 'success'
    else
      @report.worker_status = 'failure'
    end
    @report.save
  end

  private
    def parse_dmidecode
      # System Information
      if @report.data["dmidecode"]["output"] =~ /^System Information$\s+Manufacturer: (.+?)$\s+Product Name: (.+?)$\s+Version: (.*?)$\s+Serial Number: (.+?)$/m
        @information[:name] = $2
        @information[:product_name] = $4
      else
        raise ReportWorker::InformationMissing
      end

      # BIOS Information
      if @report.data["dmidecode"]["output"] =~ /^BIOS Information$\s+Vendor: (.+?)$\s+Version: (.+?)$/m
        @information[:bios_vendor] = $1
        @information[:bios_version] = $2
      else
        raise ReportWorker::InformationMissing
      end

      # PCI information
      @information[:pci_slots] = 0
      @report.data["dmidecode"]["output"].match(/^System Slot Information$\s+Designation: PCI(\d+)/m) do |m|
        @information[:pci_slots] += 1
      end

      # PCIe information
      @information[:pcie_slots] = 0
      @report.data["dmidecode"]["output"].match(/^System Slot Information$\s+Designation: PCI EXPRESS (.+?)$/m) do |m|
        @information[:pcie_slots] += 1
      end
    end

    def parse_lshw
      # DIMM slots
      if @report.data["lshw"]["output"] =~ /^Physical Memory Array$\s+Location: (.+?)$\s+Use: System Memory$\s+Error Correction Type: (.+?)$\s+Maximum Capacity: (.+?)$\s+Error Information Handle: (.+?)$\s+Number Of Devices: (\d+)$/m
        @information[:dimm_slots] = $5
      else
        raise ReportWorker::InformationMissing
      end
    end

    def parse_reporter
      # Location information
      if @report.data["reporter"]["ipaddress"] =~ /^10\.(20[4-8])\.(\d{1,2})\.\d{1,3}$/
        @information[:location] = "D#{$1}-#{$2}"
      else
        @information[:location] = 'Unknown'
      end
    end
end
