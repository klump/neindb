class Component
  class Nic < Component
    store_accessor :properties, :primary_mac, :speed, :ports, :mac_addresses
  end
end
