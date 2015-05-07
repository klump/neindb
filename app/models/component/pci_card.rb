class Component::PciCard < Component
  store_accessor :properties, :class

  validates :class, presence: true
end
