json.array!(@components) do |component|
  json.extract! component, :id, :name, :vendor, :speed_mbits
  json.url component_nic_url(component, format: :json)
end
