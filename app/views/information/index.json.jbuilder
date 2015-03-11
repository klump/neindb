json.array!(@information) do |information|
  json.extract! information, :id, :name, :data
  json.url information_url(information, format: :json)
end
