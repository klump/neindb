class Component
  class RamModule < Component
    store_accessor :properties, :size_bytes, :speed_mhz, :ecc, :rank

    validates :size_bytes, presence: true, numericality: {only_integer: true}
    validates :speed_mhz, presence: true, numericality: true
    validates :ecc, presence: true, inclusion: [true, false]
    validates :rank, presence: true
  end
end
