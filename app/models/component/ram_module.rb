class Component::RamModule < Component
  store_accessor :properties, :size_bytes, :speed_mhz, :ecc, :rank, :ram_type, :form_factor, :serials

  validates :size_bytes, presence: true, numericality: {only_integer: true}
  validates :speed_mhz, presence: true, numericality: true
  validates :ecc, inclusion: [true, false]
  validates :rank, presence: true, allow_nil: true
  validates :ram_type, presence: true
  validates :form_factor, presence: true

  after_initialize :ensure_default_values

  def self.find_by_serial serial
    Component::RamModule.where("properties -> 'serials' ? :serial", {serial: serial}).first
  end

  private
    def ensure_default_values
      write_store_attribute(:properties, :serials, []) unless serials
    end  
end
