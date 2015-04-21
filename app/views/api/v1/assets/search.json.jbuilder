json.array!(@assets) do |asset|
  json.extract! asset, :id, :name, :type, :properties
  json.url asset_url(asset, format: :json)
end
