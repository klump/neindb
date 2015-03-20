class Component
  class Cpu < Component
    store_accessor :properties, :speed_mhz, :cores, :threads_per_core, :extensions

    validates :speed_mhz, presence: true, numericality: true
    validates :cores, presence: true, numericality: {only_integer: true}
    validates :threads_per_core, presence: true, numericality: {only_integer: true}

    after_initialize :ensure_default_values

    private
      def ensure_default_values
        write_store_attribute(:properties, :extensions, []) unless extensions
      end  
  end
end
