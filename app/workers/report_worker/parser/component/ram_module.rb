#
# This worker can use information to build a Component::RamModule
# object from a report.
#
class ReportWorker::Parser::Component::RamModule < ReportWorker::Parser
  TYPES = %w(computer)

  REQUIRE = [:dmidecode]

  def initialize(report)
    @report = report
    @ram_modules = []
  end

  def analyze
    # extract the necessary information to identify the computer
    parse_dmidecode

    @ram_modules.each do |information|
      ram_module = ::Component::RamModule.find_or_initialize_by(name: information[:part_number])

      ram_module.size_bytes = information[:size_bytes]
      ram_module.vendor = information[:vendor]
      ram_module.speed_mhz = information[:speed_mhz]
      ram_module.ecc = information[:ecc]
      ram_module.rank = information[:rank]
      ram_module.ram_type = information[:ram_type]
      ram_module.form_factor= information[:form_factor]
      # Add the serial of the current module to the collection of serials for this type of ram module
      ram_module.serials << information[:serial]
      ram_module.serials.uniq!

      ram_module.save!

      # Update association between component and asset (ram and computer)
      attachment = ram_module.attached_components.find_or_initialize_by(asset: @report.asset, connector: information[:locator])
      attachment.save!
    end

    return true
  end

  private
    def parse_dmidecode
      @report.data["dmidecode"]["output"].scan(/DMI type 17.+?^Memory Device$\s+Array Handle:(.+?)$\s+Error Information Handle:(.+?)$\s+Total Width:(.+?)$\s+Data Width:(.+?)$\s+Size:(.+?)$\s+Form Factor:(.+?)$\s+Set:(.+?)$\s+Locator:(.+?)$\s+Bank Locator:(.+?)$\s+Type:(.+?)$\s+Type Detail:(.+?)$\s+Speed:(.+?)$\s+Manufacturer:(.+?)$\s+Serial Number:(.+?)$\s+Asset Tag:(.+?)$\s+Part Number:(.+?)$(\s+Rank:(.+?)$)?/m).each do |m|
        m.map! { |e| e.strip unless e.nil? }

        # Check if it is a valid RAM module (dmidecode provides information about empty slots and other memory devices as well...) and weed out the invalid ones
        if ( ( m[4] != 'No Module Installed' ) && ( m[5] != 'Chip') && ( m[7] != 'SYSTEM ROM' ) )
          # Assign the values
          information = {}
          ecc = m[1]
          size = m[4]
          speed = m[11]
          information[:serial] = m[13]
          information[:form_factor] = m[5]
          information[:locator] = m[7]
          information[:ram_type] = m[9]
          information[:vendor] = m[12]
          information[:part_number] = m[15]
          information[:rank] = m[17]

          # Do some special converstions
          information[:ecc] = ( ( ( ecc =~ /^No/i ) || ( ecc.empty? ) ) ? false : true )
          information[:size_bytes] = case size
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
          information[:speed_mhz] = case speed
          when /^(\d+)\s+kHz$/
            speed.to_f / 1024
          when /^(\d+)\s+MHz$/
            speed.to_f
          when /^(\d+)\s+GHz$/
            speed.to_f * 1024
          else
            0
          end

          # Add the ram module to the ram modules collection
          @ram_modules << information
        end
      end
    end
end
