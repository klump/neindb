  class Component
  class HardDrive < Component
    store_accessor :properties, :model, :fireware_version, :size_bytes, :rpm

    validates :model, presence: true
    validates :fireware_version, presence: true
    validates :size_bytes, presence: true, numericality: {only_integer: true}
    validates :rpm, presence: true, numericality: {only_integer: true}
  end
end
