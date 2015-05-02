#
# This worker can use information to build a Asset::Computer
# object from a report.
#
class ReportWorker::Parser::Asset::Computer < ReportWorker::Parser
  TYPES = %w(computer)

  def initialize(report)
    @report = report
    @information = {}
  end

  def analyze
    # extract the necessary information to identify the computer
    parse_dmidecode
    parse_reporter

    @computer = ::Asset::Computer.find_or_create_by(name: @information[:name])
    # Duplicate the object for comparison
    @computer_old = @computer.dup

    @computer.product_name = @information[:product_name]
    @computer.bios_vendor = @information[:bios_vendor]
    @computer.bios_version = @information[:bios_version]
    @computer.pci_slots = @information[:pci_slots]
    @computer.pcie_slots = @information[:pcie_slots]
    @computer.dimm_slots = @information[:dimm_slots]
    @computer.location = @information[:location]

    # Compare the old and the new computer
    compare(@computer_old, @computer)

    @computer.save
  end

  private
    def parse_dmidecode
      # System Information
      if @report.data["dmidecode"]["output"] =~ /^System Information$\s+Manufacturer: (.+?)$\s+Product Name: (.+?)$\s+Version: (.*?)$\s+Serial Number: (.+?)$/m
        @information[:name] = $2
        @information[:product_name] = $4
      else
        raise ReportWorker::Parser::InformationMissing
      end

      # BIOS Information
      if @report.data["dmidecode"]["output"] =~ /^BIOS Information$\s+Vendor: (.+?)$\s+Version: (.+?)$/m
        @information[:bios_vendor] = $1
        @information[:bios_version] = $2
      else
        raise ReportWorker::Parser::InformationMissing
      end

      # PCI information
      @information[:pci_slots] = @report.data["dmidecode"]["output"].scan(/^System Slot Information$\s+Designation: PCI(\d+)/m).count

      # PCIe information
      @information[:pcie_slots] = @report.data["dmidecode"]["output"].scan(/^System Slot Information$\s+Designation: PCI EXPRESS (.+?)$/m).count
      
      # DIMM slots
      if @report.data["dmidecode"]["output"] =~ /^Physical Memory Array$\s+Location: System Board Or Motherboard$\s+Use: System Memory$\s+Error Correction Type: (.+?)$\s+Maximum Capacity: (.+?)$\s+Error Information Handle: (.+?)$\s+Number Of Devices: (\d+)$/m
        @information[:dimm_slots] = $4
      else
        raise ReportWorker::Parser::InformationMissing
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

    def compare(old, new)
      diff = old.diff(new)

      return if diff.empty?

      # Create a revision
      rev = Revision.new
      rev.data = diff
      rev.revisionable = new
      rev.trigger = @report

      rev.save
    end
end
