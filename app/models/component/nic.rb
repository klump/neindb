class Component
  class Nic < Component
    store_accessor :properties, :speed_mbits, :ports, :mac_addresses

    validates :speed_mbits, presence: true, numericality: true
    validates :ports, presence: true, numericality: {only_integer: true}
    validate :validate_mac_addresses

    after_initialize :ensure_default_values

    def primary_mac
      return unless mac_addresses.is_a?(Array)
      mac_addresses.sort.first
    end

    def mac_addresses=(macs)
      raise TypeError.new("Expected macs to be of type Array") unless macs.is_a? Array

      macs.map! do |mac|
        mac.gsub!(/[.:-]/,'')
        mac.downcase!
      end

      super(macs)
    end

    private
      def validate_mac_addresses
        unless mac_addresses.is_a? Array
          errors.add :mac_addresses, "must be an array of MAC addresses"
          return
        end
        mac_addresses.each do |mac|
          unless mac =~ /^[a-f0-9]{12}$/
            errors.add :mac_addresses, "contains an invalid MAC address"
            return
          end
        end
      end

      def ensure_default_values
        write_store_attribute(:properties, :mac_addresses, []) unless mac_addresses
      end  
  end
end
