json.array!(@revisions) do |revision|
  json.extract! revision, :id, :data
  json.url revision_url(revision, format: :json)
end
