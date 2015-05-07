class Component::HardDrive < Component
  TECHNOLOGIES = %W(hdd ssd)

  store_accessor :properties, :model, :fireware_version, :size_bytes, :rpm, :technology

  validates :model, presence: true
  validates :fireware_version, presence: true
  validates :size_bytes, presence: true, numericality: {only_integer: true}
  validates :rpm, presence: true, numericality: {only_integer: true}
  validates :technology, presence: true, inclusion: TECHNOLOGIES
end
