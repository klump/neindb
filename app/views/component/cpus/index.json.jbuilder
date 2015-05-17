json.array!(@components) do |component|
  json.extract! component, :id, :name, :vendor, :speed_mhz
  json.url component_cpu_url(component, format: :json)
end
