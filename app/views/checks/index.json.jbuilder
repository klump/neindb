json.array!(@checks) do |check|
  json.extract! check, :id, :name, :status, :message, :data
  json.url check_url(check, format: :json)
end
