require "rails_helper"

describe Component::Nic, type: :model do
  describe "#valid_mac_addresses" do
    it "returns no errors if all mac addresses are valid" do
      valid_macs = %w(11:22:33:44:55:66 1234.5678.abcd abcd-1234-9904)

      nic = Component::Nic.new(mac_addresses: valid_macs)
      nic.send(:validate_mac_addresses)

      expect(nic.errors.count).to be 0
    end
    it "returns errors if at least one mac address is invalid" do
      valid_macs = %w(11:22:33:44:55:66:77 invalid-mac-ad)

      nic = Component::Nic.new(mac_addresses: valid_macs)
      nic.send(:validate_mac_addresses)

      expect(nic.errors.count).to be 1
    end
  end
  describe "#primary_mac" do
    it "returns the lexicographically first mac address" do
      mac_addresses = %w(11:22:33:44:55:66 1234.5678.abcd abcd-1234-9904)

      nic = Component::Nic.new(mac_addresses: mac_addresses)
      
      expect(nic.primary_mac).to be "112233445566"
    end
    it "returns nil if there are no mac addresses set" do
      nic = Component::Nic.new

      expect(nic.primary_mac).to be nil
    end
  end
end
