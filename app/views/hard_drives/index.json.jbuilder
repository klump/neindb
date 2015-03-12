json.array!(@hard_drives) do |hard_drive|
  json.extract! hard_drive, :id, :serial, :model, :device_model, :firmware, :capacity_bytes, :rpm
  json.url hard_drive_url(hard_drive, format: :json)
end
