  class Asset 
  class Computer < Asset
    store_accessor :properties, :bios_version, :bios_vendor, :location, :pci_slots, :dimm_slots, :product_name
  end
end
