class Asset::Computer < Asset
  store_accessor :properties, :bios_version, :bios_vendor, :location, :pci_slots, :pcie_slots, :dimm_slots, :product_name

  validates :bios_version, presence: true
  validates :bios_vendor, presence: true
  validates :pci_slots, presence: true, numericality: {only_integer: true}
  validates :pcie_slots, presence: true, numericality: {only_integer: true}
  validates :dimm_slots, presence: true, numericality: {only_integer: true}

  after_initialize :ensure_default_values

  def cpu_speed_mhz
    components.where(type: Component::Cpu).first.speed_mhz
  end

  def ram_size_bytes
    size = 0
    components.where(type: Component::RamModule).each do |ram|
      size += ram.size_bytes
    end
    size
  end

  private
    def ensure_default_values 
      product_name ||= 'Unknown'
    end
end
