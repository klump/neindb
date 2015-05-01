class Asset 
  class Computer < Asset
    store_accessor :properties, :bios_version, :bios_vendor, :location, :pci_slots, :pcie_slots, :dimm_slots, :product_name

    validates :product_name, presence: true
    validates :bios_version, presence: true
    validates :bios_vendor, presence: true
    validates :location, presence: true
    validates :pci_slots, presence: true, numericality: {only_integer: true}
    validates :pcie_slots, presence: true, numericality: {only_integer: true}
    validates :dimm_slots, presence: true, numericality: {only_integer: true}
  end
end
