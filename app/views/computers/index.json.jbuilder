json.array!(@computers) do |computer|
  json.extract! computer, :id, :serial, :location, :dimm_slots, :pci_slots, :bios_vendor, :bios_version, :vendor, :product_name
  json.url computer_url(computer, format: :json)
end
