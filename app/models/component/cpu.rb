class Component
  class Cpu < Component
    store_accessor :properties, :speed_mhz, :cores, :threads_per_core

    validates :speed_mhz, presence: true, numericality: true
    validates :cores, presence: true, numericality: {only_integer: true}
    validates :threads_per_core, presence: true, numericality: {only_integer: true}
  end
end
