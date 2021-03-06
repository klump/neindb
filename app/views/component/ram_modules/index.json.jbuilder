json.array!(@components) do |component|
  json.extract! component, :id, :name, :vendor, :speed_mhz, :size_bytes, :ram_type
  json.url component_ram_module_url(component, format: :json)
end
