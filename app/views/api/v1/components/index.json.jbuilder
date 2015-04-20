json.array!(@components) do |component|
  json.extract! component, :id, :type, :attributes
  json.url component_url(component, format: :json)
end
