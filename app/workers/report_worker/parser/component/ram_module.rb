#
# This worker can use information to build a Component::RamModule
# object from a report.
#
class ReportWorker::Parser::Component::RamModule < ReportWorker::Parser
  TYPES = %w(computer)

  REQUIRE = [:dmidecode]

  def initialize(report)
    @report = report
    @ram_modules = {}
  end

  def analyze
    # extract the necessary information to identify the computer
    parse_dmidecode

    p @ram_modules

    @ram_modules.each do |serial,information|
      ram_module = ::Component::RamModule.find_or_initialize_by(name: serial)

      ram_module.size_bytes = information[:size_bytes]
      ram_module.vendor = information[:vendor]
      ram_module.speed_mhz = information[:speed_mhz]
      ram_module.ecc = information[:ecc]
      ram_module.rank = information[:rank]
      ram_module.ram_type = information[:ram_type]
      ram_module.form_factor= information[:form_factor]
      ram_module.part_number = information[:part_number]

      ram_module.save!

      # update association between component and asset (ram and computer)
      attachment = ram_module.attached_components.find_or_initialize_by(asset: @report.asset)
      attachment.connector = information[:locator]
      attachment.save!
    end

    return true
  end

  private
    def parse_dmidecode
      @report.data["dmidecode"]["output"].scan(/DMI type 17.+?$\s+Error Information Handle:\s+(.+?)$.+?\s+Size:\s+(.+?)$\s+Form Factor:\s+(.+?)$.+?^\s+Locator:\s+(.+?)$.+?^\s+Type:\s+(.+?)$.+?^\s+Speed:\s+(.+?)$\s+Manufacturer:\s*?(.+?)$\s+Serial Number:\s*?(.+?)$.+?^\s+Part Number:\s*?(.+?)$\s+Rank:\s+(.+?)$/m).each do |m|
        m.map! { |e| e.strip }
        # Check if it is a valid RAM module (dmidecode provides information about empty slots and other memory devices as well...)
        if ( ( m[1] != 'No Module Installed' ) && ( m[2] != 'Chip') && ( m[3] != 'SYSTEM ROM' ) )
          # Assign the values
          ecc = m[0]
          size = m[1]
          speed = m[5]
          serial = m[7]
          @ram_modules[serial] ||= {}
          @ram_modules[serial][:form_factor] = m[2]
          @ram_modules[serial][:locator] = m[3]
          @ram_modules[serial][:ram_type] = m[4]
          @ram_modules[serial][:vendor] = m[6]
          @ram_modules[serial][:part_number] = m[8]
          @ram_modules[serial][:rank] = m[9]

          # Do some special converstions
          @ram_modules[serial][:ecc] = ( ( ( ecc =~ /^No/i ) || ( ecc.empty? ) ) ? false : true )
          @ram_modules[serial][:size_bytes] = case size
          when /^(\d+)\s+B$/
            size.to_i
          when /^(\d+)\s+kB$/
            ( size.to_f * 1024 ).to_i
          when /^(\d+)\s+MB$/
            ( size.to_f * 1024 * 1024 ).to_i
          when /^(\d+)\s+GB$/
            ( size.to_f * 1024 * 1024 * 1024 ).to_i
          else
            0
          end
          @ram_modules[serial][:speed_mhz] = case speed
          when /^(\d+)\s+kHz$/
            speed.to_f / 1024
          when /^(\d+)\s+MHz$/
            speed.to_f
          when /^(\d+)\s+GHz$/
            speed.to_f * 1024
          else
            0
          end
        end
      end
    end
end
