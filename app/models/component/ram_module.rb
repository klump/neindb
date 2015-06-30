class Component::RamModule < Component
  store_accessor :properties, :size_bytes, :speed_mhz, :ecc, :rank, :ram_type, :form_factor, :part_number

  validates :size_bytes, presence: true, numericality: {only_integer: true}
  validates :speed_mhz, presence: true, numericality: true
  validates :ecc, inclusion: [true, false]
  validates :rank, presence: true, allow_nil: true
  validates :ram_type, presence: true
  validates :form_factor, presence: true
end
