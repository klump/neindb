json.array!(@revisions) do |revision|
  json.extract! revision, :id, :old_data, :new_data
  json.url revision_url(revision, format: :json)
end
