json.array!(@hard_drives) do |hard_drife|
  json.extract! hard_drife, :id, :serial, :model, :device_model, :firmware, :capacity_bytes, :rpm
  json.url hard_drife_url(hard_drife, format: :json)
end
